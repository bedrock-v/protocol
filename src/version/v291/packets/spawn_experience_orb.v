module packets

import protocol.serializer
import protocol.version.v291.types

pub struct SpawnExperienceOrbPacket {
pub mut:
	position types.Vector3f
	amount   i32
}

pub fn (p &SpawnExperienceOrbPacket) pid() u16 {
	return 66
}

pub fn (p &SpawnExperienceOrbPacket) name() string {
	return 'SpawnExperienceOrbPacket'
}

pub fn (p &SpawnExperienceOrbPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SpawnExperienceOrbPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.write_varint32(p.amount)
}

pub fn (mut p SpawnExperienceOrbPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.Vector3f.decode(mut r)!
	p.amount = r.read_varint32()!
}
