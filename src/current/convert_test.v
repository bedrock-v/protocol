module current

import protocol.serializer
import protocol.types as model

// A shield carries the ticks it has been blocking for as extra data, which
// widens the descriptor by eight bytes over an ordinary item.

fn item_instance_extra_data_len(item model.ItemStack) !int {
	mut w := serializer.new_writer()
	item_instance(item).encode(mut w)
	mut r := serializer.new_reader(w.bytes())
	r.read_varint32()!
	r.le_u16()!
	r.read_varuint32()!
	r.read_varint32()!
	return r.read_string_bytes()!.len
}

fn item_descriptor_v2_extra_data_len(item model.ItemStack) !int {
	mut w := serializer.new_writer()
	item_descriptor_v2(item).encode(mut w)
	mut r := serializer.new_reader(w.bytes())
	r.le_i16()!
	r.le_u16()!
	r.read_varuint32()!
	if r.bool()! {
		r.read_varuint32()!
		r.read_varint32()!
	}
	r.read_varuint32()!
	return r.read_string_bytes()!.len
}

fn test_shield_writes_blocking_ticks_extra_data() {
	assert item_instance_extra_data_len(model.ItemStack{ id: shield_runtime_id, count: 1 })! == 18
	assert item_descriptor_v2_extra_data_len(model.ItemStack{ id: shield_runtime_id, count: 1 })! == 18
	assert item_instance_extra_data_len(model.ItemStack{ id: 1, count: 1 })! == 10
}
