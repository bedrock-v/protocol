module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v944.types as types_944

pub struct InventorySlotPacket {
pub mut:
	container_id        u32
	slot                u32
	container_name_data ?types_944.FullContainerName
	storage_item        ?types.NetworkItemStackDescriptorV2
	item                types.NetworkItemStackDescriptorV2
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
	if v := p.container_name_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := p.storage_item {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	p.item.encode(mut w)
}

pub fn (mut p InventorySlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.read_varuint32()!
	p.slot = r.read_varuint32()!
	if r.bool()! {
		p.container_name_data = types_944.FullContainerName.decode(mut r)!
	}
	if r.bool()! {
		p.storage_item = types.NetworkItemStackDescriptorV2.decode(mut r)!
	}
	p.item = types.NetworkItemStackDescriptorV2.decode(mut r)!
}
