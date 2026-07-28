module packets

import protocol.serializer

pub struct PlayerActionPacket {
pub mut:
	eid    i64
	action i32
	x      i32
	y      i32
	z      i32
	face   i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 0xab
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i32(p.action)
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.be_i32(p.face)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.action = r.be_i32()!
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.face = r.be_i32()!
}
