module packets

import serializer
import version.v291.types

pub struct SpawnParticleEffectPacket {
pub mut:
	dimension_id     u8
	unique_entity_id i64 = -1
	position         types.Vector3f
	identifier       string
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
	w.write_varint64(p.unique_entity_id)
	p.position.encode(mut w)
	w.write_string(p.identifier)
}

pub fn (mut p SpawnParticleEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = r.u8()!
	p.unique_entity_id = r.read_varint64()!
	p.position = types.Vector3f.decode(mut r)!
	p.identifier = r.read_string()!
}
