module src

import src.serializer
import src.types

pub struct CreativeContentPacket {
pub mut:
	groups []types.CreativeGroupEntry
	items  []types.CreativeItemEntry
}

pub fn (p &CreativeContentPacket) pid() u16 {
	return creative_content_packet
}

pub fn (p &CreativeContentPacket) name() string {
	return 'CreativeContentPacket'
}

pub fn (p &CreativeContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CreativeContentPacket) decode_payload(mut r serializer.Reader) ! {
	group_count := int(r.read_varuint32()!)
	p.groups = []types.CreativeGroupEntry{}
	for _ in 0 .. group_count {
		p.groups << r.read_creative_group_entry()!
	}
	item_count := int(r.read_varuint32()!)
	p.items = []types.CreativeItemEntry{}
	for _ in 0 .. item_count {
		p.items << r.read_creative_item_entry()!
	}
}

pub fn (p &CreativeContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.groups.len))
	for group in p.groups {
		w.write_creative_group_entry(group)
	}
	w.write_varuint32(u32(p.items.len))
	for item in p.items {
		w.write_creative_item_entry(item)
	}
}
