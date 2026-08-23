module packets

import protocol.serializer
import protocol.version.v662.types

pub struct InventoryContentPacket {
pub mut:
	inventory_id u32
	slots        []types.NetworkItemStackDescriptor
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
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.inventory_id = r.read_varuint32()!
	{
		count := r.read_count()!
		p.slots = []types.NetworkItemStackDescriptor{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.slots << types.NetworkItemStackDescriptor.decode(mut r)!
		}
	}
}
