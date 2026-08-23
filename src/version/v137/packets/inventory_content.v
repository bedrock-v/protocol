module packets

import protocol.serializer
import protocol.version.v137.types

pub struct InventoryContentPacket {
pub mut:
	window_id u32
	items     []types.ItemData
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
	w.write_varuint32(p.window_id)
	w.write_varuint32(u32(p.items.len))
	for item in p.items {
		item.encode(mut w)
	}
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.read_varuint32()!
	count := r.read_count()!
	p.items = []types.ItemData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.items << types.ItemData.decode(mut r)!
	}
}
