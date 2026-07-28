module packets

import protocol.serializer
import protocol.version.v291.types

pub struct SpawnParticleEffectPacket {
pub mut:
	dimension_id u8
	position     types.Vector3f
	identifier   string
}

pub fn (p &SpawnParticleEffectPacket) pid() u16 {
	return 118
}

pub fn (p &SpawnParticleEffectPacket) name() string {
	return 'SpawnParticleEffectPacket'
}

pub fn (p &SpawnParticleEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SpawnParticleEffectPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.dimension_id)
	p.position.encode(mut w)
	w.write_string(p.identifier)
}

pub fn (mut p SpawnParticleEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = r.u8()!
	p.position = types.Vector3f.decode(mut r)!
	p.identifier = r.read_string()!
}
