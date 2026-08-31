module packets

import bedrock_v.nbt
import protocol.serializer

pub struct ItemComponentEntry {
pub mut:
	name string
	data nbt.RootTag
}

pub fn (t ItemComponentEntry) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_nbt_compound_root(t.data)
}

pub fn ItemComponentEntry.decode(mut r serializer.Reader) !ItemComponentEntry {
	return ItemComponentEntry{
		name: r.read_string()!
		data: r.read_nbt_compound_root()!
	}
}

pub struct ItemComponentPacket {
pub mut:
	items []ItemComponentEntry
}

pub fn (p &ItemComponentPacket) pid() u16 {
	return 162
}

pub fn (p &ItemComponentPacket) name() string {
	return 'ItemComponentPacket'
}

pub fn (p &ItemComponentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemComponentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.items.len))
	for item in p.items {
		item.encode(mut w)
	}
}

pub fn (mut p ItemComponentPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.items = []ItemComponentEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.items << ItemComponentEntry.decode(mut r)!
	}
}
