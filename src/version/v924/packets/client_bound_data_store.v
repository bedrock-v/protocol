module packets

import protocol.serializer

pub struct ClientBoundDataStoreValueDouble {
pub mut:
	value f64
}

pub struct ClientBoundDataStoreValueNone {}

pub struct ClientBoundDataStoreValueBool {
pub mut:
	value bool
}

pub struct ClientBoundDataStoreValueInt64 {
pub mut:
	value i64
}

pub struct ClientBoundDataStoreValueString {
pub mut:
	value string
}

pub struct ClientBoundDataStoreValueList {
pub mut:
	values []ClientBoundDataStoreValue
}

pub struct ClientBoundDataStoreMapEntry {
pub mut:
	key   string
	value ClientBoundDataStoreValue
}

pub struct ClientBoundDataStoreValueMap {
pub mut:
	values []ClientBoundDataStoreMapEntry
}

pub type ClientBoundDataStoreValue = ClientBoundDataStoreValueBool
	| ClientBoundDataStoreValueDouble
	| ClientBoundDataStoreValueInt64
	| ClientBoundDataStoreValueList
	| ClientBoundDataStoreValueMap
	| ClientBoundDataStoreValueNone
	| ClientBoundDataStoreValueString

pub fn (t ClientBoundDataStoreValue) encode(mut w serializer.Writer) {
	match t {
		ClientBoundDataStoreValueNone {
			w.le_i32(0)
		}
		ClientBoundDataStoreValueBool {
			w.le_i32(1)
			w.bool(t.value)
		}
		ClientBoundDataStoreValueInt64 {
			w.le_i32(2)
			w.le_i64(t.value)
		}
		ClientBoundDataStoreValueDouble {
			w.le_i32(3)
			w.le_f64(t.value)
		}
		ClientBoundDataStoreValueString {
			w.le_i32(4)
			w.write_string(t.value)
		}
		ClientBoundDataStoreValueList {
			w.le_i32(5)
			w.write_varuint32(u32(t.values.len))
			for v in t.values {
				v.encode(mut w)
			}
		}
		ClientBoundDataStoreValueMap {
			w.le_i32(6)
			w.write_varuint32(u32(t.values.len))
			for e in t.values {
				w.write_string(e.key)
				e.value.encode(mut w)
			}
		}
	}
}

pub fn ClientBoundDataStoreValue.decode(mut r serializer.Reader) !ClientBoundDataStoreValue {
	d := r.le_i32()!
	match d {
		0 {
			return ClientBoundDataStoreValueNone{}
		}
		1 {
			return ClientBoundDataStoreValueBool{
				value: r.bool()!
			}
		}
		2 {
			return ClientBoundDataStoreValueInt64{
				value: r.le_i64()!
			}
		}
		3 {
			return ClientBoundDataStoreValueDouble{
				value: r.le_f64()!
			}
		}
		4 {
			return ClientBoundDataStoreValueString{
				value: r.read_string()!
			}
		}
		5 {
			count := int(r.read_varuint32()!)
			mut values := []ClientBoundDataStoreValue{cap: count}
			for _ in 0 .. count {
				values << ClientBoundDataStoreValue.decode(mut r)!
			}
			return ClientBoundDataStoreValueList{
				values: values
			}
		}
		6 {
			count := int(r.read_varuint32()!)
			mut values := []ClientBoundDataStoreMapEntry{cap: count}
			for _ in 0 .. count {
				values << ClientBoundDataStoreMapEntry{
					key:   r.read_string()!
					value: ClientBoundDataStoreValue.decode(mut r)!
				}
			}
			return ClientBoundDataStoreValueMap{
				values: values
			}
		}
		else {
			return error('invalid ClientBoundDataStoreValue ${d}')
		}
	}
}

pub struct DataStoreControlDouble {
pub mut:
	value f64
}

pub struct DataStoreControlBool {
pub mut:
	value bool
}

pub struct DataStoreControlString {
pub mut:
	value string
}

pub type DataStoreControlValue = DataStoreControlBool
	| DataStoreControlDouble
	| DataStoreControlString

pub fn (t DataStoreControlValue) encode(mut w serializer.Writer) {
	match t {
		DataStoreControlDouble {
			w.write_varuint32(0)
			w.le_f64(t.value)
		}
		DataStoreControlBool {
			w.write_varuint32(1)
			w.bool(t.value)
		}
		DataStoreControlString {
			w.write_varuint32(2)
			w.write_string(t.value)
		}
	}
}

pub fn DataStoreControlValue.decode(mut r serializer.Reader) !DataStoreControlValue {
	d := r.read_varuint32()!
	match d {
		0 {
			return DataStoreControlDouble{
				value: r.le_f64()!
			}
		}
		1 {
			return DataStoreControlBool{
				value: r.bool()!
			}
		}
		2 {
			return DataStoreControlString{
				value: r.read_string()!
			}
		}
		else {
			return error('invalid DataStoreControlValue ${d}')
		}
	}
}

pub struct DataStoreUpdate {
pub mut:
	data_store_name   string
	property          string
	path              string
	data              DataStoreControlValue = DataStoreControlDouble{}
	update_count      u32
	path_update_count u32
}

pub struct DataStoreChange {
pub mut:
	data_store_name string
	property        string
	update_count    u32
	new_value       ClientBoundDataStoreValue = ClientBoundDataStoreValueDouble{}
}

pub struct DataStoreRemove {
pub mut:
	data_store_name string
}

pub type ClientBoundDataStoreUpdate = DataStoreChange | DataStoreRemove | DataStoreUpdate

pub fn (t ClientBoundDataStoreUpdate) encode(mut w serializer.Writer) {
	match t {
		DataStoreUpdate {
			w.write_varuint32(0)
			w.write_string(t.data_store_name)
			w.write_string(t.property)
			w.write_string(t.path)
			t.data.encode(mut w)
			w.le_u32(t.update_count)
			w.le_u32(t.path_update_count)
		}
		DataStoreChange {
			w.write_varuint32(1)
			w.write_string(t.data_store_name)
			w.write_string(t.property)
			w.le_u32(t.update_count)
			t.new_value.encode(mut w)
		}
		DataStoreRemove {
			w.write_varuint32(2)
			w.write_string(t.data_store_name)
		}
	}
}

pub fn ClientBoundDataStoreUpdate.decode(mut r serializer.Reader) !ClientBoundDataStoreUpdate {
	d := r.read_varuint32()!
	match d {
		0 {
			return DataStoreUpdate{
				data_store_name:   r.read_string()!
				property:          r.read_string()!
				path:              r.read_string()!
				data:              DataStoreControlValue.decode(mut r)!
				update_count:      r.le_u32()!
				path_update_count: r.le_u32()!
			}
		}
		1 {
			return DataStoreChange{
				data_store_name: r.read_string()!
				property:        r.read_string()!
				update_count:    r.le_u32()!
				new_value:       ClientBoundDataStoreValue.decode(mut r)!
			}
		}
		2 {
			return DataStoreRemove{
				data_store_name: r.read_string()!
			}
		}
		else {
			return error('invalid ClientBoundDataStoreUpdate ${d}')
		}
	}
}

pub struct ClientBoundDataStorePacket {
pub mut:
	updates []ClientBoundDataStoreUpdate
}

pub fn (p &ClientBoundDataStorePacket) pid() u16 {
	return 330
}

pub fn (p &ClientBoundDataStorePacket) name() string {
	return 'ClientBoundDataStorePacket'
}

pub fn (p &ClientBoundDataStorePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataStorePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.updates.len))
	for u in p.updates {
		u.encode(mut w)
	}
}

pub fn (mut p ClientBoundDataStorePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.updates = []ClientBoundDataStoreUpdate{cap: count}
	for _ in 0 .. count {
		p.updates << ClientBoundDataStoreUpdate.decode(mut r)!
	}
}
