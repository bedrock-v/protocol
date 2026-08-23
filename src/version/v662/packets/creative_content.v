module packets

import protocol.serializer
import protocol.version.v662.types

pub struct WriteEntry {
pub mut:
	creative_net_id u32
	item_instance   types.NetworkItemInstanceDescriptor
}

pub fn (e WriteEntry) encode(mut w serializer.Writer) {
	w.write_varuint32(e.creative_net_id)
	e.item_instance.encode(mut w)
}

pub fn WriteEntry.decode(mut r serializer.Reader) !WriteEntry {
	return WriteEntry{
		creative_net_id: r.read_varuint32()!
		item_instance:   types.NetworkItemInstanceDescriptor.decode(mut r)!
	}
}

pub struct CreativeContentPacket {
pub mut:
	write_entries []WriteEntry
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
	w.write_varuint32(u32(p.write_entries.len))
	for e in p.write_entries {
		e.encode(mut w)
	}
}

pub fn (mut p CreativeContentPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.write_entries = []WriteEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.write_entries << WriteEntry.decode(mut r)!
	}
}
