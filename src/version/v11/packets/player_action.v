module packets

import serializer

pub struct PlayerActionPacket {
pub mut:
	action i32
	x      i32
	y      i32
	z      i32
	face   i32
	eid    i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 0xa3
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.action)
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.be_i32(p.face)
	w.be_i32(p.eid)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.be_i32()!
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.face = r.be_i32()!
	p.eid = r.be_i32()!
}
