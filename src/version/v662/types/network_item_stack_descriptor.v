module types

import protocol.serializer

pub struct NetworkItemStackDescriptor {
pub mut:
	id               i32
	stack_size       u16
	aux_value        u32
	has_net_id       bool
	net_id           i32
	block_runtime_id i32
	user_data_buffer []u8
}

pub fn (t NetworkItemStackDescriptor) encode(mut w serializer.Writer) {
	w.write_varint32(t.id)
	if t.id != 0 {
		w.le_u16(t.stack_size)
		w.write_varuint32(t.aux_value)
		w.bool(t.has_net_id)
		if t.has_net_id {
			w.write_varint32(t.net_id)
		}
		w.write_varint32(t.block_runtime_id)
		w.write_item_extra_data(t.user_data_buffer)
	}
}

pub fn NetworkItemStackDescriptor.decode(mut r serializer.Reader) !NetworkItemStackDescriptor {
	mut t := NetworkItemStackDescriptor{}
	t.id = r.read_varint32()!
	if t.id != 0 {
		t.stack_size = r.le_u16()!
		t.aux_value = r.read_varuint32()!
		t.has_net_id = r.bool()!
		if t.has_net_id {
			t.net_id = r.read_varint32()!
		}
		t.block_runtime_id = r.read_varint32()!
		t.user_data_buffer = r.read_item_extra_data()!
	}
	return t
}
