module packets

import serializer
import version.v137.types

pub struct ChangeDimensionPacket {
pub mut:
	dimension i32
	position  types.Vector3f
	respawn   bool
}

pub fn (p &ChangeDimensionPacket) pid() u16 {
	return 61
}

pub fn (p &ChangeDimensionPacket) name() string {
	return 'ChangeDimensionPacket'
}

pub fn (p &ChangeDimensionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChangeDimensionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.dimension)
	p.position.encode(mut w)
	w.bool(p.respawn)
}

pub fn (mut p ChangeDimensionPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	p.position = types.Vector3f.decode(mut r)!
	p.respawn = r.bool()!
}
