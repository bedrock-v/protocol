module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v944.types as types_944

pub struct InventoryContentPacket {
pub mut:
	inventory_id        u32
	slots               []types.NetworkItemStackDescriptorV2
	container_name_data types_944.FullContainerName
	storage_item        types.NetworkItemStackDescriptorV2
}

pub fn (p &InventoryContentPacket) pid() u16 {
	return 49
}

pub fn (p &InventoryContentPacket) name() string {
	return 'InventoryContentPacket'
}

pub fn (p &InventoryContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventoryContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.inventory_id)
	w.write_varuint32(u32(p.slots.len))
	for e in p.slots {
		e.encode(mut w)
	}
	p.container_name_data.encode(mut w)
	p.storage_item.encode(mut w)
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.inventory_id = r.read_varuint32()!
	{
		count := int(r.read_varuint32()!)
		p.slots = []types.NetworkItemStackDescriptorV2{cap: count}
		for _ in 0 .. count {
			p.slots << types.NetworkItemStackDescriptorV2.decode(mut r)!
		}
	}
	p.container_name_data = types_944.FullContainerName.decode(mut r)!
	p.storage_item = types.NetworkItemStackDescriptorV2.decode(mut r)!
}
