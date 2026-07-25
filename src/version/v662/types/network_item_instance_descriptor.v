module types

import serializer

pub struct NetworkItemInstanceDescriptor {
pub mut:
	id               i32
	stack_size       u16
	aux_value        u32
	block_runtime_id i32
	user_data_buffer []u8
}

pub fn (t NetworkItemInstanceDescriptor) encode(mut w serializer.Writer) {
	w.write_varint32(t.id)
	if t.id != 0 {
		w.le_u16(t.stack_size)
		w.write_varuint32(t.aux_value)
		w.write_varint32(t.block_runtime_id)
		w.write_string_bytes(t.user_data_buffer)
	}
}

pub fn NetworkItemInstanceDescriptor.decode(mut r serializer.Reader) !NetworkItemInstanceDescriptor {
	mut t := NetworkItemInstanceDescriptor{}
	t.id = r.read_varint32()!
	if t.id != 0 {
		t.stack_size = r.le_u16()!
		t.aux_value = r.read_varuint32()!
		t.block_runtime_id = r.read_varint32()!
		t.user_data_buffer = r.read_string_bytes()!
	}
	return t
}
