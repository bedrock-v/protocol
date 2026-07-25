module packets

import serializer
import version.v859.types

pub struct DebugDrawerPacket {
pub mut:
	shapes []types.DebugShape
}

pub fn (p &DebugDrawerPacket) pid() u16 { return 328 }

pub fn (p &DebugDrawerPacket) name() string { return 'DebugDrawerPacket' }

pub fn (p &DebugDrawerPacket) can_be_sent_before_login() bool { return false }

pub fn (p &DebugDrawerPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shapes.len))
	for e in p.shapes {
		e.encode(mut w)
	}
}

pub fn (mut p DebugDrawerPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	mut shapes := []types.DebugShape{cap: count}
	for _ in 0 .. count {
		shapes << types.DebugShape.decode(mut r)!
	}
	p.shapes = shapes
}
