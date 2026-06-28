module protocol

import serializer
import types

pub struct InventorySlotPacket {
pub mut:
	window_id      int
	inventory_slot int
	container_name ?types.FullContainerName
	storage        ?types.ItemStackWrapper
	item           types.ItemStackWrapper
}

pub fn (p &InventorySlotPacket) pid() u16 {
	return inventory_slot_packet
}

pub fn (p &InventorySlotPacket) name() string {
	return 'InventorySlotPacket'
}

pub fn (p &InventorySlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = int(r.read_varuint32()!)
	p.inventory_slot = int(r.read_varuint32()!)
	if r.bool()! {
		p.container_name = r.read_full_container_name()!
	} else {
		p.container_name = none
	}
	if r.bool()! {
		p.storage = r.read_network_item_stack_descriptor()!
	} else {
		p.storage = none
	}
	p.item = r.read_network_item_stack_descriptor()!
}

pub fn (p &InventorySlotPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.window_id))
	w.write_varuint32(u32(p.inventory_slot))
	if name := p.container_name {
		w.bool(true)
		w.write_full_container_name(name)
	} else {
		w.bool(false)
	}
	if storage := p.storage {
		w.bool(true)
		w.write_network_item_stack_descriptor(storage)
	} else {
		w.bool(false)
	}
	w.write_network_item_stack_descriptor(p.item)
}
