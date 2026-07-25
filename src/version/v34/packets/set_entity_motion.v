module packets

import serializer

pub struct MotionEntry {
pub mut:
	eid i64
	x   f32
	y   f32
	z   f32
}

pub struct SetEntityMotionPacket {
pub mut:
	entities []MotionEntry
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0xae
}

pub fn (p &SetEntityMotionPacket) name() string {
	return 'SetEntityMotionPacket'
}

pub fn (p &SetEntityMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityMotionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.entities.len))
	for e in p.entities {
		w.be_i64(e.eid)
		w.be_f32(e.x)
		w.be_f32(e.y)
		w.be_f32(e.z)
	}
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	for _ in 0 .. count {
		p.entities << MotionEntry{
			eid: r.be_i64()!
			x:   r.be_f32()!
			y:   r.be_f32()!
			z:   r.be_f32()!
		}
	}
}
