module packets

import protocol.serializer
import protocol.version.v137.types

pub struct ExplodePacket {
pub mut:
	position types.Vector3f
	radius   f32
	records  []types.Vector3i
}

pub fn (p &ExplodePacket) pid() u16 {
	return 23
}

pub fn (p &ExplodePacket) name() string {
	return 'ExplodePacket'
}

pub fn (p &ExplodePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ExplodePacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.write_varint32(i32(p.radius * 32))
	w.write_varuint32(u32(p.records.len))
	for record in p.records {
		record.encode(mut w)
	}
}

pub fn (mut p ExplodePacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.Vector3f.decode(mut r)!
	p.radius = f32(r.read_varint32()!) / 32.0
	count := int(r.read_varuint32()!)
	p.records = []types.Vector3i{cap: count}
	for _ in 0 .. count {
		p.records << types.Vector3i.decode(mut r)!
	}
}
