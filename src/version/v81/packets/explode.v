module packets

import protocol.serializer

pub struct ExplodeRecord {
pub mut:
	x i8
	y i8
	z i8
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
	return 0x15
}

pub fn (p &ExplodePacket) name() string {
	return 'ExplodePacket'
}

pub fn (p &ExplodePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ExplodePacket) encode_payload(mut w serializer.Writer) {
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.radius)
	w.be_i32(i32(p.records.len))
	for rec in p.records {
		w.i8(rec.x)
		w.i8(rec.y)
		w.i8(rec.z)
	}
}

pub fn (mut p ExplodePacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.radius = r.be_f32()!
	count := int(r.be_i32()!)
	for _ in 0 .. count {
		p.records << ExplodeRecord{
			x: r.i8()!
			y: r.i8()!
			z: r.i8()!
		}
	}
}
