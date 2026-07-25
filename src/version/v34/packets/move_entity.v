module packets

import serializer

pub struct MoveEntityEntry {
pub mut:
	eid      i64
	x        f32
	y        f32
	z        f32
	yaw      f32
	head_yaw f32
	pitch    f32
}

pub struct MoveEntityPacket {
pub mut:
	entities []MoveEntityEntry
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 0x9c
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.entities.len))
	for e in p.entities {
		w.be_i64(e.eid)
		w.be_f32(e.x)
		w.be_f32(e.y)
		w.be_f32(e.z)
		w.be_f32(e.yaw)
		w.be_f32(e.head_yaw)
		w.be_f32(e.pitch)
	}
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	for _ in 0 .. count {
		p.entities << MoveEntityEntry{
			eid:      r.be_i64()!
			x:        r.be_f32()!
			y:        r.be_f32()!
			z:        r.be_f32()!
			yaw:      r.be_f32()!
			head_yaw: r.be_f32()!
			pitch:    r.be_f32()!
		}
	}
}
