module packets

import protocol.serializer

pub struct PlayerListEntry {
pub mut:
	uuid []u8
	eid  i64
	name string
	slim bool
	skin string
}

pub struct PlayerListPacket {
pub mut:
	typ     u8
	entries []PlayerListEntry
}

pub fn (p &PlayerListPacket) pid() u16 {
	return 0xc3
}

pub fn (p &PlayerListPacket) name() string {
	return 'PlayerListPacket'
}

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.typ)
	w.be_i32(i32(p.entries.len))
	for e in p.entries {
		if p.typ == 0 {
			w.write_raw(e.uuid)
			w.be_i64(e.eid)
			w.write_string_be(e.name)
			w.u8(if e.slim { u8(1) } else { u8(0) })
			w.write_string_be(e.skin)
		} else {
			w.write_raw(e.uuid)
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.typ = r.u8()!
	count := int(r.be_i32()!)
	for _ in 0 .. count {
		if p.typ == 0 {
			p.entries << PlayerListEntry{
				uuid: r.read_raw(16)!
				eid:  r.be_i64()!
				name: r.read_string_be()!
				slim: r.u8()! > 0
				skin: r.read_string_be()!
			}
		} else {
			p.entries << PlayerListEntry{
				uuid: r.read_raw(16)!
			}
		}
	}
}
