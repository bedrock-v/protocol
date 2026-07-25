module packets

import serializer

pub struct AnimatePacket {
pub mut:
	action i8
	eid    i32
}

pub fn (p &AnimatePacket) pid() u16 {
	return 0xac
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.action)
	w.be_i32(p.eid)
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.i8()!
	p.eid = r.be_i32()!
}
