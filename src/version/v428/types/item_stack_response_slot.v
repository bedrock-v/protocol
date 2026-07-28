module types

import protocol.serializer

pub struct ItemStackResponseSlot {
pub mut:
	slot                  u8
	hotbar_slot           u8
	count                 u8
	stack_network_id      i32
	custom_name           string
	durability_correction i32
}

pub fn (t ItemStackResponseSlot) encode(mut w serializer.Writer) {
	w.u8(t.slot)
	w.u8(t.hotbar_slot)
	w.u8(t.count)
	w.write_varint32(t.stack_network_id)
	w.write_string(t.custom_name)
	w.write_varint32(t.durability_correction)
}

pub fn ItemStackResponseSlot.decode(mut r serializer.Reader) !ItemStackResponseSlot {
	return ItemStackResponseSlot{
		slot:                  r.u8()!
		hotbar_slot:           r.u8()!
		count:                 r.u8()!
		stack_network_id:      r.read_varint32()!
		custom_name:           r.read_string()!
		durability_correction: r.read_varint32()!
	}
}
