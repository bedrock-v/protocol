module packets

import serializer

pub struct SetEntityMotionPacket {
pub mut:
	eid     i32
	speed_x i16
	speed_y i16
	speed_z i16
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0xa7
}

pub fn (p &SetEntityMotionPacket) name() string {
	return 'SetEntityMotionPacket'
}

pub fn (p &SetEntityMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityMotionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_i16(p.speed_x)
	w.be_i16(p.speed_y)
	w.be_i16(p.speed_z)
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.speed_x = r.be_i16()!
	p.speed_y = r.be_i16()!
	p.speed_z = r.be_i16()!
}
