module packets

import serializer

pub struct SetEntityLinkPacket {
pub mut:
	from i64
	to   i64
	typ  u8
}

pub fn (p &SetEntityLinkPacket) pid() u16 {
	return 0xaf
}

pub fn (p &SetEntityLinkPacket) name() string {
	return 'SetEntityLinkPacket'
}

pub fn (p &SetEntityLinkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityLinkPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.from)
	w.be_i64(p.to)
	w.u8(p.typ)
}

pub fn (mut p SetEntityLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.from = r.be_i64()!
	p.to = r.be_i64()!
	p.typ = r.u8()!
}
