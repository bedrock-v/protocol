module types

import serializer
import version.v407.enums

pub struct ItemStackResponseSlot {
pub mut:
	slot             u8
	hotbar_slot      u8
	count            u8
	stack_network_id i32
}

pub fn (t ItemStackResponseSlot) encode(mut w serializer.Writer) {
	w.u8(t.slot)
	w.u8(t.hotbar_slot)
	w.u8(t.count)
	w.write_varint32(t.stack_network_id)
}

pub fn ItemStackResponseSlot.decode(mut r serializer.Reader) !ItemStackResponseSlot {
	return ItemStackResponseSlot{
		slot:             r.u8()!
		hotbar_slot:      r.u8()!
		count:            r.u8()!
		stack_network_id: r.read_varint32()!
	}
}

pub struct ItemStackResponseContainer {
pub mut:
	container enums.ContainerSlotType
	items     []ItemStackResponseSlot
}

pub fn (t ItemStackResponseContainer) encode(mut w serializer.Writer) {
	t.container.encode(mut w)
	w.write_varuint32(u32(t.items.len))
	for item in t.items {
		item.encode(mut w)
	}
}

pub fn ItemStackResponseContainer.decode(mut r serializer.Reader) !ItemStackResponseContainer {
	mut t := ItemStackResponseContainer{}
	t.container = enums.ContainerSlotType.decode(mut r)!
	count := int(r.read_varuint32()!)
	t.items = []ItemStackResponseSlot{cap: count}
	for _ in 0 .. count {
		t.items << ItemStackResponseSlot.decode(mut r)!
	}
	return t
}
