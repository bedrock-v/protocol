module packets

import serializer

pub struct SetEntityLinkPacket {
pub mut:
	from i64
	to   i64
	type u8
}

pub fn (p &SetEntityLinkPacket) pid() u16 {
	return 0x2a
}

pub fn (p &SetEntityLinkPacket) name() string {
	return 'SetEntityLinkPacket'
}

pub fn (p &SetEntityLinkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityLinkPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.from)
	w.write_varint64(p.to)
	w.u8(p.type)
}

pub fn (mut p SetEntityLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.from = r.read_varint64()!
	p.to = r.read_varint64()!
	p.type = r.u8()!
}
