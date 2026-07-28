module types

import serializer

pub struct NetworkItemStackDescriptorV2 {
pub mut:
	id               i16
	stack_size       u16
	aux_value        u32
	net_id           ?i32
	block_runtime_id u32
	user_data_buffer []u8
}

pub fn (t NetworkItemStackDescriptorV2) encode(mut w serializer.Writer) {
	w.le_i16(t.id)
	w.le_u16(t.stack_size)
	w.write_varuint32(t.aux_value)
	if v := t.net_id {
		w.bool(true)
		w.write_varint32(v)
	} else {
		w.bool(false)
	}
	w.write_varuint32(t.block_runtime_id)
	w.write_item_extra_data(t.user_data_buffer)
}

pub fn NetworkItemStackDescriptorV2.decode(mut r serializer.Reader) !NetworkItemStackDescriptorV2 {
	mut t := NetworkItemStackDescriptorV2{}
	t.id = r.le_i16()!
	t.stack_size = r.le_u16()!
	t.aux_value = r.read_varuint32()!
	if r.bool()! {
		t.net_id = r.read_varint32()!
	}
	t.block_runtime_id = r.read_varuint32()!
	t.user_data_buffer = r.read_item_extra_data()!
	return t
}
