module packets

import protocol.serializer

pub struct ExplodeRecord {
pub mut:
	x i32
	y u32
	z i32
}

pub struct ExplodePacket {
pub mut:
	x       f32
	y       f32
	z       f32
	radius  f32
	records []ExplodeRecord
}

pub fn (p &ExplodePacket) pid() u16 {
	return 0x19
}

pub fn (p &ExplodePacket) name() string {
	return 'ExplodePacket'
}

pub fn (p &ExplodePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ExplodePacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.radius)
	w.write_varuint32(u32(p.records.len))
	for rec in p.records {
		w.write_varint32(rec.x)
		w.write_varuint32(rec.y)
		w.write_varint32(rec.z)
	}
}

pub fn (mut p ExplodePacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.radius = r.le_f32()!
	n := r.read_count()!
	for _ in 0 .. n {
		p.records << ExplodeRecord{
			x: r.read_varint32()!
			y: r.read_varuint32()!
			z: r.read_varint32()!
		}
	}
}
