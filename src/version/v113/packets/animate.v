module packets

import serializer

pub struct AnimatePacket {
pub mut:
	action i32
	eid    u64
	float  f32
}

pub fn (p &AnimatePacket) pid() u16 {
	return 0x2c
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.action)
	w.write_varuint64(p.eid)
	if (p.action & 0x80) != 0 {
		w.le_f32(p.float)
	}
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.read_varint32()!
	p.eid = r.read_varuint64()!
	if (p.action & 0x80) != 0 {
		p.float = r.le_f32()!
	}
}
