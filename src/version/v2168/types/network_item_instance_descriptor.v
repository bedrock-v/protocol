module types

import protocol.serializer

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
	w.le_u16(t.stack_size)
	w.write_varuint32(t.aux_value)
	w.write_varint32(t.block_runtime_id)
	w.write_item_extra_data(t.user_data_buffer)
}

pub fn NetworkItemInstanceDescriptor.decode(mut r serializer.Reader) !NetworkItemInstanceDescriptor {
	return NetworkItemInstanceDescriptor{
		id:               r.read_varint32()!
		stack_size:       r.le_u16()!
		aux_value:        r.read_varuint32()!
		block_runtime_id: r.read_varint32()!
		user_data_buffer: r.read_item_extra_data()!
	}
}
