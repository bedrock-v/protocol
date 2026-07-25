module packets

import serializer

pub struct ChangeDimensionPacket {
pub mut:
	dimension i32
	x         f32
	y         f32
	z         f32
	unknown   bool
}

pub fn (p &ChangeDimensionPacket) pid() u16 {
	return 0x3d
}

pub fn (p &ChangeDimensionPacket) name() string {
	return 'ChangeDimensionPacket'
}

pub fn (p &ChangeDimensionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChangeDimensionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.dimension)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.bool(p.unknown)
}

pub fn (mut p ChangeDimensionPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.unknown = r.bool()!
}
