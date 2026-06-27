module src

import src.serializer

pub const data_store_value_double = u8(0)
pub const data_store_value_bool = u8(1)
pub const data_store_value_string = u8(2)

pub struct DataStoreUpdate {
pub mut:
	name              string
	property          string
	path              string
	value_type        u8
	double_value      f64
	bool_value        bool
	string_value      string
	update_count      u32
	path_update_count u32
}

pub struct ServerboundDataStorePacket {
pub mut:
	update DataStoreUpdate
}

pub fn (p &ServerboundDataStorePacket) pid() u16 {
	return serverbound_data_store_packet
}

pub fn (p &ServerboundDataStorePacket) name() string {
	return 'ServerboundDataStorePacket'
}

pub fn (p &ServerboundDataStorePacket) can_be_sent_before_login() bool {
	return false
}

fn read_data_store_update(mut r serializer.Reader) !DataStoreUpdate {
	mut u := DataStoreUpdate{
		name:     r.read_string()!
		property: r.read_string()!
		path:     r.read_string()!
	}
	u.value_type = u8(r.read_varuint32()!)
	match u.value_type {
		data_store_value_double { u.double_value = r.le_f64()! }
		data_store_value_bool { u.bool_value = r.bool()! }
		data_store_value_string { u.string_value = r.read_string()! }
		else {}
	}
	u.update_count = r.le_u32()!
	u.path_update_count = r.le_u32()!
	return u
}

fn write_data_store_update(mut w serializer.Writer, u DataStoreUpdate) {
	w.write_string(u.name)
	w.write_string(u.property)
	w.write_string(u.path)
	w.write_varuint32(u32(u.value_type))
	match u.value_type {
		data_store_value_double { w.le_f64(u.double_value) }
		data_store_value_bool { w.bool(u.bool_value) }
		data_store_value_string { w.write_string(u.string_value) }
		else {}
	}
	w.le_u32(u.update_count)
	w.le_u32(u.path_update_count)
}

pub fn (mut p ServerboundDataStorePacket) decode_payload(mut r serializer.Reader) ! {
	p.update = read_data_store_update(mut r)!
}

pub fn (p &ServerboundDataStorePacket) encode_payload(mut w serializer.Writer) {
	write_data_store_update(mut w, p.update)
}
