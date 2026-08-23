module packets

import protocol.serializer
import protocol.version.v407.types

pub struct InventoryContentPacket {
pub mut:
	container_id u32
	contents     []types.NetItemData
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
	w.write_varuint32(p.container_id)
	w.write_varuint32(u32(p.contents.len))
	for item in p.contents {
		item.encode(mut w)
	}
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.read_varuint32()!
	count := r.read_count()!
	p.contents = []types.NetItemData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.contents << types.NetItemData.decode(mut r)!
	}
}
