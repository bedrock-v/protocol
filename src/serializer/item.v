module serializer

import types

pub fn (mut r Reader) read_item_stack_without_stack_id() !types.ItemStack {
	id := int(r.read_varint32()!)
	if id == 0 {
		return types.item_stack_null()
	}
	count := int(r.le_u16()!)
	meta := int(r.read_varuint32()!)
	block_runtime_id := int(r.read_varint32()!)
	raw_extra_data := r.read_string_bytes()!
	return types.ItemStack{
		id:               id
		meta:             meta
		count:            count
		block_runtime_id: block_runtime_id
		raw_extra_data:   raw_extra_data
	}
}

pub fn (mut w Writer) write_item_stack_without_stack_id(s types.ItemStack) {
	if s.id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(i32(s.id))
	w.le_u16(u16(s.count))
	w.write_varuint32(u32(s.meta))
	w.write_varint32(i32(s.block_runtime_id))
	w.write_string_bytes(s.raw_extra_data)
}

pub fn (mut r Reader) read_item_stack_wrapper() !types.ItemStackWrapper {
	id := int(r.read_varint32()!)
	if id == 0 {
		return types.ItemStackWrapper{
			stack_id:   0
			item_stack: types.item_stack_null()
		}
	}
	count := int(r.le_u16()!)
	meta := int(r.read_varuint32()!)
	has_net_id := r.bool()!
	stack_id := if has_net_id { int(r.read_varint32()!) } else { 0 }
	block_runtime_id := int(r.read_varint32()!)
	raw_extra_data := r.read_string_bytes()!
	return types.ItemStackWrapper{
		stack_id: stack_id
		item_stack: types.ItemStack{
			id:               id
			meta:             meta
			count:            count
			block_runtime_id: block_runtime_id
			raw_extra_data:   raw_extra_data
		}
	}
}

pub fn (mut w Writer) write_item_stack_wrapper(wrapper types.ItemStackWrapper) {
	s := wrapper.item_stack
	if s.id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(i32(s.id))
	w.le_u16(u16(s.count))
	w.write_varuint32(u32(s.meta))
	has_net_id := wrapper.stack_id != 0
	w.bool(has_net_id)
	if has_net_id {
		w.write_varint32(i32(wrapper.stack_id))
	}
	w.write_varint32(i32(s.block_runtime_id))
	w.write_string_bytes(s.raw_extra_data)
}

pub fn (mut r Reader) read_network_item_stack_descriptor() !types.ItemStackWrapper {
	id := int(r.le_i16()!)
	count := int(r.le_u16()!)
	meta := int(r.read_varuint32()!)
	has_net_id := r.bool()!
	mut variant := 0
	mut stack_id := 0
	if has_net_id {
		variant = int(r.read_varuint32()!)
		stack_id = int(r.read_varint32()!)
	}
	block_runtime_id := int(r.read_varuint32()!)
	raw_extra_data := r.read_string_bytes()!
	return types.ItemStackWrapper{
		stack_id:         stack_id
		stack_id_variant: variant
		item_stack: types.ItemStack{
			id:               id
			meta:             meta
			count:            count
			block_runtime_id: block_runtime_id
			raw_extra_data:   raw_extra_data
		}
	}
}

pub fn (mut w Writer) write_network_item_stack_descriptor(wrapper types.ItemStackWrapper) {
	s := wrapper.item_stack
	w.le_i16(i16(s.id))
	w.le_u16(u16(s.count))
	w.write_varuint32(u32(s.meta))
	has_net_id := wrapper.stack_id != 0
	w.bool(has_net_id)
	if has_net_id {
		w.write_varuint32(u32(wrapper.stack_id_variant))
		w.write_varint32(i32(wrapper.stack_id))
	}
	w.write_varuint32(u32(s.block_runtime_id))
	w.write_string_bytes(s.raw_extra_data)
}

pub fn (mut r Reader) read_full_container_name() !types.FullContainerName {
	container_id := int(r.u8()!)
	mut dynamic_id := ?int(none)
	if r.bool()! {
		dynamic_id = int(r.le_u32()!)
	}
	return types.FullContainerName{
		container_id: container_id
		dynamic_id:   dynamic_id
	}
}

pub fn (mut w Writer) write_full_container_name(name types.FullContainerName) {
	w.u8(u8(name.container_id))
	if id := name.dynamic_id {
		w.bool(true)
		w.le_u32(u32(id))
	} else {
		w.bool(false)
	}
}
