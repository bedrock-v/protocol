module packets

import serializer
import version.v137.types

pub struct InventorySlotPacket {
pub mut:
	window_id      u32
	inventory_slot u32
	item           types.ItemData
}

pub fn (p &InventorySlotPacket) pid() u16 {
	return 50
}

pub fn (p &InventorySlotPacket) name() string {
	return 'InventorySlotPacket'
}

pub fn (p &InventorySlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventorySlotPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.window_id)
	w.write_varuint32(p.inventory_slot)
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.read_varuint32()!
	p.inventory_slot = r.read_varuint32()!
	p.item = types.ItemData.decode(mut r)!
}
