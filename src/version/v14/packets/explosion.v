module packets

import protocol.serializer

pub struct ExplosionRecord {
pub mut:
	x i8
	y i8
	z i8
}

pub struct ExplosionPacket {
pub mut:
	x       f32
	y       f32
	z       f32
	radius  f32
	records []ExplosionRecord
}

pub fn (p &ExplosionPacket) pid() u16 {
	return 0x9a
}

pub fn (p &ExplosionPacket) name() string {
	return 'ExplosionPacket'
}

pub fn (p &ExplosionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ExplosionPacket) encode_payload(mut w serializer.Writer) {
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.radius)
	w.be_i32(i32(p.records.len))
	for record in p.records {
		w.i8(record.x)
		w.i8(record.y)
		w.i8(record.z)
	}
}

pub fn (mut p ExplosionPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.radius = r.be_f32()!
	count := r.be_i32()!
	p.records = []ExplosionRecord{cap: int(count)}
	for _ in 0 .. count {
		if r.remaining() == 0 {
			break
		}
		p.records << ExplosionRecord{
			x: r.i8()!
			y: r.i8()!
			z: r.i8()!
		}
	}
}
