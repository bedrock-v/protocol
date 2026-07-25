module packets

import serializer

pub struct SetEntityMotionEntry {
pub mut:
	eid  i64
	motx f32
	moty f32
	motz f32
}

pub struct SetEntityMotionPacket {
pub mut:
	entities []SetEntityMotionEntry
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0x9f
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
		w.be_f32(e.motx)
		w.be_f32(e.moty)
		w.be_f32(e.motz)
	}
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	p.entities = []SetEntityMotionEntry{cap: count}
	for _ in 0 .. count {
		p.entities << SetEntityMotionEntry{
			eid:  r.be_i64()!
			motx: r.be_f32()!
			moty: r.be_f32()!
			motz: r.be_f32()!
		}
	}
}
