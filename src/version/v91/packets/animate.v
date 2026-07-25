module packets

import serializer

pub struct AnimatePacket {
pub mut:
	action u8
	eid    i32
}

pub fn (p &AnimatePacket) pid() u16 {
	return 0x2b
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action)
	w.write_varint32(p.eid)
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.u8()!
	p.eid = r.read_varint32()!
}
