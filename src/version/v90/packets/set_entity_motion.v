module packets

import serializer

pub struct EntityMotion {
pub mut:
	eid      i64
	motion_x f32
	motion_y f32
	motion_z f32
}

pub struct SetEntityMotionPacket {
pub mut:
	entities []EntityMotion
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0x24
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
		w.be_f32(e.motion_x)
		w.be_f32(e.motion_y)
		w.be_f32(e.motion_z)
	}
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	n := int(r.be_i32()!)
	for _ in 0 .. n {
		p.entities << EntityMotion{
			eid:      r.be_i64()!
			motion_x: r.be_f32()!
			motion_y: r.be_f32()!
			motion_z: r.be_f32()!
		}
	}
}
