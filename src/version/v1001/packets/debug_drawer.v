module packets

import protocol.serializer
import protocol.version.v1001.types

pub struct DebugDrawerPacket {
pub mut:
	shapes []types.DebugShape
}

pub fn (p &DebugDrawerPacket) pid() u16 {
	return 328
}

pub fn (p &DebugDrawerPacket) name() string {
	return 'DebugDrawerPacket'
}

pub fn (p &DebugDrawerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DebugDrawerPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shapes.len))
	for e in p.shapes {
		e.encode(mut w)
	}
}

pub fn (mut p DebugDrawerPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.shapes = []types.DebugShape{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.shapes << types.DebugShape.decode(mut r)!
	}
}
