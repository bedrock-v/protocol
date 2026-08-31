module packets

import protocol.serializer
import protocol.version.v662.types

pub struct InventorySlotPacket {
pub mut:
	container_id              i32
	slot                      u32
	container_name_dynamic_id i32
	item                      types.NetworkItemStackDescriptor
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
	w.write_varint32(p.container_id)
	w.write_varuint32(p.slot)
	w.write_varint32(p.container_name_dynamic_id)
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.read_varint32()!
	p.slot = r.read_varuint32()!
	p.container_name_dynamic_id = r.read_varint32()!
	p.item = types.NetworkItemStackDescriptor.decode(mut r)!
}
