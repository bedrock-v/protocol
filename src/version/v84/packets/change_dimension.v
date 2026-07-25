module packets

import serializer

pub struct ChangeDimensionPacket {
pub mut:
	dimension u8
	x         f32
	y         f32
	z         f32
	unknown   u8
}

pub fn (p &ChangeDimensionPacket) pid() u16 {
	return 0x36
}

pub fn (p &ChangeDimensionPacket) name() string {
	return 'ChangeDimensionPacket'
}

pub fn (p &ChangeDimensionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChangeDimensionPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.dimension)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.u8(p.unknown)
}

pub fn (mut p ChangeDimensionPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.u8()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.unknown = r.u8()!
}
