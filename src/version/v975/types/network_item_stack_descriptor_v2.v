module types

import protocol.serializer

pub struct ItemStackNetId {
pub mut:
	value i32
}

pub struct ItemStackRequestId {
pub mut:
	value i32
}

pub struct ItemStackLegacyRequestId {
pub mut:
	value i32
}

pub type ItemStackNetIdVariant = ItemStackLegacyRequestId | ItemStackNetId | ItemStackRequestId

pub fn (t ItemStackNetIdVariant) encode(mut w serializer.Writer) {
	match t {
		ItemStackNetId {
			w.write_varuint32(0)
			w.write_varint32(t.value)
		}
		ItemStackRequestId {
			w.write_varuint32(1)
			w.write_varint32(t.value)
		}
		ItemStackLegacyRequestId {
			w.write_varuint32(2)
			w.write_varint32(t.value)
		}
	}
}

pub fn ItemStackNetIdVariant.decode(mut r serializer.Reader) !ItemStackNetIdVariant {
	d := r.read_varuint32()!
	match d {
		0 {
			return ItemStackNetId{
				value: r.read_varint32()!
			}
		}
		1 {
			return ItemStackRequestId{
				value: r.read_varint32()!
			}
		}
		2 {
			return ItemStackLegacyRequestId{
				value: r.read_varint32()!
			}
		}
		else {
			return error('invalid ItemStackNetIdVariant ${d}')
		}
	}
}

pub struct NetworkItemStackDescriptorV2 {
pub mut:
	id               i16
	stack_size       u16
	aux_value        u32
	net_id           ?ItemStackNetIdVariant
	block_runtime_id u32
	user_data_buffer []u8
}

pub fn (t NetworkItemStackDescriptorV2) encode(mut w serializer.Writer) {
	w.le_i16(t.id)
	w.le_u16(t.stack_size)
	w.write_varuint32(t.aux_value)
	if v := t.net_id {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.write_varuint32(t.block_runtime_id)
	if t.id == 0 {
		w.write_varuint32(0)
		return
	}
	w.write_item_extra_data(t.user_data_buffer)
}

pub fn NetworkItemStackDescriptorV2.decode(mut r serializer.Reader) !NetworkItemStackDescriptorV2 {
	mut t := NetworkItemStackDescriptorV2{}
	t.id = r.le_i16()!
	t.stack_size = r.le_u16()!
	t.aux_value = r.read_varuint32()!
	if r.bool()! {
		t.net_id = ItemStackNetIdVariant.decode(mut r)!
	}
	t.block_runtime_id = r.read_varuint32()!
	if t.id == 0 {
		r.read_varuint32()!
		return t
	}
	t.user_data_buffer = r.read_item_extra_data()!
	return t
}
