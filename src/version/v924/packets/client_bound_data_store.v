module packets

import protocol.serializer

pub struct ClientBoundDataStoreValueDouble {
pub mut:
	value f64
}

pub struct ClientBoundDataStoreValueBool {
pub mut:
	value bool
}

pub struct ClientBoundDataStoreValueString {
pub mut:
	value string
}

pub type ClientBoundDataStoreValue = ClientBoundDataStoreValueBool
	| ClientBoundDataStoreValueDouble
	| ClientBoundDataStoreValueString

pub fn (t ClientBoundDataStoreValue) encode(mut w serializer.Writer) {
	match t {
		ClientBoundDataStoreValueDouble {
			w.write_varuint32(0)
			w.le_f64(t.value)
		}
		ClientBoundDataStoreValueBool {
			w.write_varuint32(1)
			w.bool(t.value)
		}
		ClientBoundDataStoreValueString {
			w.write_varuint32(2)
			w.write_string(t.value)
		}
	}
}

pub fn ClientBoundDataStoreValue.decode(mut r serializer.Reader) !ClientBoundDataStoreValue {
	d := r.read_varuint32()!
	match d {
		0 {
			return ClientBoundDataStoreValueDouble{
				value: r.le_f64()!
			}
		}
		1 {
			return ClientBoundDataStoreValueBool{
				value: r.bool()!
			}
		}
		2 {
			return ClientBoundDataStoreValueString{
				value: r.read_string()!
			}
		}
		else {
			return error('invalid ClientBoundDataStoreValue ${d}')
		}
	}
}

pub struct DataStoreUpdate {
pub mut:
	data_store_name   string
	property          string
	path              string
	data              ClientBoundDataStoreValue = ClientBoundDataStoreValueDouble{}
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
				data:              ClientBoundDataStoreValue.decode(mut r)!
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
