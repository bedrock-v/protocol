module packets

import protocol.serializer
import protocol.version.v291.types

pub struct InventorySlotPacket {
pub mut:
	container_id u32
	slot         u32
	item         types.ItemData
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
	w.write_varuint32(p.container_id)
	w.write_varuint32(p.slot)
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.read_varuint32()!
	p.slot = r.read_varuint32()!
	p.item = types.ItemData.decode(mut r)!
}
