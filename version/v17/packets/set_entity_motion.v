module packets

import protocol.serializer

pub struct SetEntityMotionEntry {
pub mut:
	eid  i32
	motx i16
	moty i16
	motz i16
}

pub struct SetEntityMotionPacket {
pub mut:
	entities []SetEntityMotionEntry
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0xa8
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
		w.be_i32(e.eid)
		w.be_i16(e.motx)
		w.be_i16(e.moty)
		w.be_i16(e.motz)
	}
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	p.entities = []SetEntityMotionEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.entities << SetEntityMotionEntry{
			eid:  r.be_i32()!
			motx: r.be_i16()!
			moty: r.be_i16()!
			motz: r.be_i16()!
		}
	}
}
