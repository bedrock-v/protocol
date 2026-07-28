module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct SpawnParticleEffectPacket {
pub mut:
	dimension_id          u8
	unique_entity_id      i64
	position              types_291.Vector3f
	identifier            string
	molang_variables_json ?string
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
	if molang := p.molang_variables_json {
		w.bool(true)
		w.write_string(molang)
	} else {
		w.bool(false)
	}
}

pub fn (mut p SpawnParticleEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = r.u8()!
	p.unique_entity_id = r.read_varint64()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.identifier = r.read_string()!
	if r.bool()! {
		p.molang_variables_json = r.read_string()!
	}
}
