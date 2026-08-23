module packets

import protocol.serializer
import protocol.version.v340.types as types_340

pub struct CreativeItemData {
pub mut:
	net_id u32
	item   types_340.ItemData
}

pub fn (t CreativeItemData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.net_id)
	t.item.encode(mut w)
}

pub fn CreativeItemData.decode(mut r serializer.Reader) !CreativeItemData {
	return CreativeItemData{
		net_id: r.read_varuint32()!
		item:   types_340.ItemData.decode(mut r)!
	}
}

pub struct CreativeContentPacket {
pub mut:
	contents []CreativeItemData
}

pub fn (p &CreativeContentPacket) pid() u16 {
	return 145
}

pub fn (p &CreativeContentPacket) name() string {
	return 'CreativeContentPacket'
}

pub fn (p &CreativeContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CreativeContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.contents.len))
	for entry in p.contents {
		entry.encode(mut w)
	}
}

pub fn (mut p CreativeContentPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.contents = []CreativeItemData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.contents << CreativeItemData.decode(mut r)!
	}
}
