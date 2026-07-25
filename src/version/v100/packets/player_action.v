module packets

import serializer

pub struct PlayerActionPacket {
pub mut:
	eid    i32
	action i32
	x      i32
	y      u32
	z      i32
	face   i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 0x24
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.write_varint32(p.action)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.write_varint32(p.face)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.action = r.read_varint32()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.face = r.read_varint32()!
}
