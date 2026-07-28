module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct InventorySlotPacket {
pub mut:
	container_id enums.ContainerID
	slot         u32
	item         types.NetworkItemStackDescriptor
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
	p.container_id.encode(mut w)
	w.write_varuint32(p.slot)
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.slot = r.read_varuint32()!
	p.item = types.NetworkItemStackDescriptor.decode(mut r)!
}
