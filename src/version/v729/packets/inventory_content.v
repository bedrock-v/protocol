module packets

import serializer
import version.v729.types
import version.v662.types as types_662

pub struct InventoryContentPacket {
pub mut:
	inventory_id           u32
	slots                  []types_662.NetworkItemStackDescriptor
	container_name_data    types.FullContainerName
	dynamic_container_size u32
}

pub fn (p &InventoryContentPacket) pid() u16 { return 49 }

pub fn (p &InventoryContentPacket) name() string { return 'InventoryContentPacket' }

pub fn (p &InventoryContentPacket) can_be_sent_before_login() bool { return false }

pub fn (p &InventoryContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.inventory_id)
	w.write_varuint32(u32(p.slots.len))
	for e in p.slots {
		e.encode(mut w)
	}
	p.container_name_data.encode(mut w)
	w.write_varuint32(p.dynamic_container_size)
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.inventory_id = r.read_varuint32()!
	{
		count := int(r.read_varuint32()!)
		p.slots = []types_662.NetworkItemStackDescriptor{cap: count}
		for _ in 0 .. count {
			p.slots << types_662.NetworkItemStackDescriptor.decode(mut r)!
		}
	}
	p.container_name_data = types.FullContainerName.decode(mut r)!
	p.dynamic_container_size = r.read_varuint32()!
}
