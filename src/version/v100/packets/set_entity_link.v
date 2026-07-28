module packets

import protocol.serializer

pub struct SetEntityLinkPacket {
pub mut:
	from i32
	to   i32
	type u8
}

pub fn (p &SetEntityLinkPacket) pid() u16 {
	return 0x29
}

pub fn (p &SetEntityLinkPacket) name() string {
	return 'SetEntityLinkPacket'
}

pub fn (p &SetEntityLinkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityLinkPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.from)
	w.write_varint32(p.to)
	w.u8(p.type)
}

pub fn (mut p SetEntityLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.from = r.read_varint32()!
	p.to = r.read_varint32()!
	p.type = r.u8()!
}
