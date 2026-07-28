module packets

import protocol.serializer
import protocol.version.v107.types

pub struct PlayerListEntry {
pub mut:
	uuid   types.EraBUuid
	eid    i64
	name   string
	second string
	third  string
}

pub struct PlayerListPacket {
pub mut:
	type    u8
	entries []PlayerListEntry
}

pub fn (p &PlayerListPacket) pid() u16 {
	return 0x40
}

pub fn (p &PlayerListPacket) name() string {
	return 'PlayerListPacket'
}

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.type)
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		if p.type == 0 {
			e.uuid.encode(mut w)
			w.write_varint64(e.eid)
			w.write_string(e.name)
			w.write_string(e.second)
			w.write_string(e.third)
		} else {
			e.uuid.encode(mut w)
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		mut e := PlayerListEntry{}
		if p.type == 0 {
			e.uuid = types.EraBUuid.decode(mut r)!
			e.eid = r.read_varint64()!
			e.name = r.read_string()!
			e.second = r.read_string()!
			e.third = r.read_string()!
		} else {
			e.uuid = types.EraBUuid.decode(mut r)!
		}
		p.entries << e
	}
}
