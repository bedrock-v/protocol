module src

import src.serializer

pub const data_store_change_update = u32(0)
pub const data_store_change_change = u32(1)
pub const data_store_change_removal = u32(2)

pub const data_store_property_none = 0
pub const data_store_property_bool = 1
pub const data_store_property_int64 = 2
pub const data_store_property_double = 3
pub const data_store_property_string = 4
pub const data_store_property_list = 5
pub const data_store_property_map = 6

pub struct DataStorePropertyValue {
pub mut:
	type_id      int
	bool_value   bool
	int64_value  i64
	double_value f64
	string_value string
	list_value   []DataStorePropertyValue
	map_value    []DataStoreMapEntry
}

pub struct DataStoreMapEntry {
pub mut:
	key   string
	value DataStorePropertyValue
}

pub struct DataStoreChangeEntry {
pub mut:
	change_type        u32
	update             DataStoreUpdate
	change_name        string
	change_property    string
	change_update_count u32
	change_new_value   DataStorePropertyValue
	removal_name       string
}

pub struct ClientboundDataStorePacket {
pub mut:
	updates []DataStoreChangeEntry
}

pub fn (p &ClientboundDataStorePacket) pid() u16 {
	return clientbound_data_store_packet
}

pub fn (p &ClientboundDataStorePacket) name() string {
	return 'ClientboundDataStorePacket'
}

pub fn (p &ClientboundDataStorePacket) can_be_sent_before_login() bool {
	return false
}

fn read_data_store_property_value(mut r serializer.Reader) !DataStorePropertyValue {
	mut v := DataStorePropertyValue{
		type_id: r.le_i32()!
	}
	match v.type_id {
		data_store_property_none {}
		data_store_property_bool { v.bool_value = r.bool()! }
		data_store_property_int64 { v.int64_value = r.le_i64()! }
		data_store_property_double { v.double_value = r.le_f64()! }
		data_store_property_string { v.string_value = r.read_string()! }
		data_store_property_list {
			count := r.read_varuint32()!
			v.list_value = []DataStorePropertyValue{}
			for _ in 0 .. count {
				v.list_value << read_data_store_property_value(mut r)!
			}
		}
		data_store_property_map {
			count := r.read_varuint32()!
			v.map_value = []DataStoreMapEntry{}
			for _ in 0 .. count {
				key := r.read_string()!
				value := read_data_store_property_value(mut r)!
				v.map_value << DataStoreMapEntry{
					key:   key
					value: value
				}
			}
		}
		else {}
	}
	return v
}

fn write_data_store_property_value(mut w serializer.Writer, v DataStorePropertyValue) {
	w.le_i32(v.type_id)
	match v.type_id {
		data_store_property_none {}
		data_store_property_bool { w.bool(v.bool_value) }
		data_store_property_int64 { w.le_i64(v.int64_value) }
		data_store_property_double { w.le_f64(v.double_value) }
		data_store_property_string { w.write_string(v.string_value) }
		data_store_property_list {
			w.write_varuint32(u32(v.list_value.len))
			for item in v.list_value {
				write_data_store_property_value(mut w, item)
			}
		}
		data_store_property_map {
			w.write_varuint32(u32(v.map_value.len))
			for entry in v.map_value {
				w.write_string(entry.key)
				write_data_store_property_value(mut w, entry.value)
			}
		}
		else {}
	}
}

pub fn (mut p ClientboundDataStorePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.updates = []DataStoreChangeEntry{}
	for _ in 0 .. count {
		mut e := DataStoreChangeEntry{
			change_type: r.read_varuint32()!
		}
		match e.change_type {
			data_store_change_update {
				e.update = read_data_store_update(mut r)!
			}
			data_store_change_change {
				e.change_name = r.read_string()!
				e.change_property = r.read_string()!
				e.change_update_count = r.le_u32()!
				e.change_new_value = read_data_store_property_value(mut r)!
			}
			data_store_change_removal {
				e.removal_name = r.read_string()!
			}
			else {}
		}
		p.updates << e
	}
}

pub fn (p &ClientboundDataStorePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.updates.len))
	for e in p.updates {
		w.write_varuint32(e.change_type)
		match e.change_type {
			data_store_change_update {
				write_data_store_update(mut w, e.update)
			}
			data_store_change_change {
				w.write_string(e.change_name)
				w.write_string(e.change_property)
				w.le_u32(e.change_update_count)
				write_data_store_property_value(mut w, e.change_new_value)
			}
			data_store_change_removal {
				w.write_string(e.removal_name)
			}
			else {}
		}
	}
}
