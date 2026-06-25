module src

import src.serializer
import src.types

pub struct SpawnExperienceOrbPacket {
pub mut:
	position types.Vector3
	amount   int
}

pub fn (p &SpawnExperienceOrbPacket) pid() u16 {
	return spawn_experience_orb_packet
}

pub fn (p &SpawnExperienceOrbPacket) name() string {
	return 'SpawnExperienceOrbPacket'
}

pub fn (p &SpawnExperienceOrbPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SpawnExperienceOrbPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = r.read_vector3()!
	p.amount = int(r.read_varint32()!)
}

pub fn (p &SpawnExperienceOrbPacket) encode_payload(mut w serializer.Writer) {
	w.write_vector3(p.position)
	w.write_varint32(i32(p.amount))
}
