module packets

import serializer

pub struct UseItemPacket {
pub mut:
	x     i32
	y     i32
	z     i32
	face  i32
	block i16
	meta  i8
	eid   i32
	fx    f32
	fy    f32
	fz    f32
}

pub fn (p &UseItemPacket) pid() u16 {
	return 0xa1
}

pub fn (p &UseItemPacket) name() string {
	return 'UseItemPacket'
}

pub fn (p &UseItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UseItemPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p UseItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.face = r.be_i32()!
	p.block = r.be_i16()!
	p.meta = r.i8()!
	p.eid = r.be_i32()!
	p.fx = r.be_f32()!
	p.fy = r.be_f32()!
	p.fz = r.be_f32()!
}
