module packets

import protocol.serializer
import protocol.version.v431.types

pub struct CreativeItemData {
pub mut:
	net_id u32
	item   types.ItemData
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
		w.write_varuint32(entry.net_id)
		entry.item.encode_instance(mut w)
	}
}

pub fn (mut p CreativeContentPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.contents = []CreativeItemData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.contents << CreativeItemData{
			net_id: r.read_varuint32()!
			item:   types.ItemData.decode_instance(mut r)!
		}
	}
}
