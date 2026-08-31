module types

import protocol.serializer

pub struct ItemStackResponseSlotInfo {
pub mut:
	requested_slot        i8
	slot                  i8
	amount                i8
	item_stack_net_id     i32
	custom_name           string
	durability_correction i32
}

pub fn (t ItemStackResponseSlotInfo) encode(mut w serializer.Writer) {
	w.i8(t.requested_slot)
	w.i8(t.slot)
	w.i8(t.amount)
	w.write_varint32(t.item_stack_net_id)
	w.write_string(t.custom_name)
	w.write_varint32(t.durability_correction)
}

pub fn ItemStackResponseSlotInfo.decode(mut r serializer.Reader) !ItemStackResponseSlotInfo {
	return ItemStackResponseSlotInfo{
		requested_slot:        r.i8()!
		slot:                  r.i8()!
		amount:                r.i8()!
		item_stack_net_id:     r.read_varint32()!
		custom_name:           r.read_string()!
		durability_correction: r.read_varint32()!
	}
}
