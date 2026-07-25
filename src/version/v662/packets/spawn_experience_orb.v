module packets

import serializer

pub struct SpawnExperienceOrbPacket {
pub mut:
	position [3]f32
	xp_value i32
}

pub fn (p &SpawnExperienceOrbPacket) pid() u16 { return 66 }

pub fn (p &SpawnExperienceOrbPacket) name() string { return 'SpawnExperienceOrbPacket' }

pub fn (p &SpawnExperienceOrbPacket) can_be_sent_before_login() bool { return false }

pub fn (p &SpawnExperienceOrbPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.xp_value)
}

pub fn (mut p SpawnExperienceOrbPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.xp_value = r.read_varint32()!
}
