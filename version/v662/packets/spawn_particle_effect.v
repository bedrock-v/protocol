module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SpawnParticleEffectPacket {
pub mut:
	dimension_id     i8
	actor_id         types.ActorUniqueID
	position         [3]f32
	effect_name      string
	molang_variables ?types.MolangVariableMap
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
	w.i8(p.dimension_id)
	p.actor_id.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_string(p.effect_name)
	if val := p.molang_variables {
		w.bool(true)
		val.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p SpawnParticleEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = r.i8()!
	p.actor_id = types.ActorUniqueID.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.effect_name = r.read_string()!
	if r.bool()! {
		p.molang_variables = types.MolangVariableMap.decode(mut r)!
	}
}
