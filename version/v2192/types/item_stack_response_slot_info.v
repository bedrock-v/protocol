module types

import protocol.serializer
import protocol.version.v2168.types as types_2168

pub struct ItemStackResponseSlotInfo {
pub mut:
	requested_slot        i8
	slot                  i8
	amount                i8
	item_stack_net_id     ?i32
	custom_name           types_2168.RedactableString
	durability_correction i32
}

pub fn (t ItemStackResponseSlotInfo) encode(mut w serializer.Writer) {
	w.i8(t.requested_slot)
	w.i8(t.slot)
	w.i8(t.amount)
	if v := t.item_stack_net_id {
		w.bool(true)
		w.write_varint32(v)
	} else {
		w.bool(false)
	}
	t.custom_name.encode(mut w)
	w.write_varint32(t.durability_correction)
}

pub fn ItemStackResponseSlotInfo.decode(mut r serializer.Reader) !ItemStackResponseSlotInfo {
	mut t := ItemStackResponseSlotInfo{}
	t.requested_slot = r.i8()!
	t.slot = r.i8()!
	t.amount = r.i8()!
	if r.bool()! {
		t.item_stack_net_id = r.read_varint32()!
	}
	t.custom_name = types_2168.RedactableString.decode(mut r)!
	t.durability_correction = r.read_varint32()!
	return t
}
