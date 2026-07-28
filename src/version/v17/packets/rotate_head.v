module packets

import protocol.serializer

pub struct RotateHeadEntry {
pub mut:
	eid i32
	yaw i8
}

pub struct RotateHeadPacket {
pub mut:
	entities []RotateHeadEntry
}

pub fn (p &RotateHeadPacket) pid() u16 {
	return 0x94
}

pub fn (p &RotateHeadPacket) name() string {
	return 'RotateHeadPacket'
}

pub fn (p &RotateHeadPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RotateHeadPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.entities.len))
	for e in p.entities {
		w.be_i32(e.eid)
		w.i8(e.yaw)
	}
}

pub fn (mut p RotateHeadPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	p.entities = []RotateHeadEntry{cap: count}
	for _ in 0 .. count {
		p.entities << RotateHeadEntry{
			eid: r.be_i32()!
			yaw: r.i8()!
		}
	}
}
