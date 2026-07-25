module packets

import serializer
import version.v662.types as types_662
import version.v729.types as types_729

pub struct InventorySlotPacket {
pub mut:
	container_id        u32
	slot                u32
	container_name_data types_729.FullContainerName
	storage_item        types_662.NetworkItemStackDescriptor
	item                types_662.NetworkItemStackDescriptor
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
	p.container_name_data.encode(mut w)
	p.storage_item.encode(mut w)
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.read_varuint32()!
	p.slot = r.read_varuint32()!
	p.container_name_data = types_729.FullContainerName.decode(mut r)!
	p.storage_item = types_662.NetworkItemStackDescriptor.decode(mut r)!
	p.item = types_662.NetworkItemStackDescriptor.decode(mut r)!
}
