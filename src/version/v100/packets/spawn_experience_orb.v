module packets

import serializer

pub struct SpawnExperienceOrbPacket {
pub mut:
	x      f32
	y      f32
	z      f32
	amount i32
}

pub fn (p &SpawnExperienceOrbPacket) pid() u16 {
	return 0x41
}

pub fn (p &SpawnExperienceOrbPacket) name() string {
	return 'SpawnExperienceOrbPacket'
}

pub fn (p &SpawnExperienceOrbPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SpawnExperienceOrbPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.write_varint32(p.amount)
}

pub fn (mut p SpawnExperienceOrbPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.amount = r.read_varint32()!
}
