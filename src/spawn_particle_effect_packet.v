module protocol

import serializer
import types

pub struct SpawnParticleEffectPacket {
pub mut:
	dimension_id          int
	actor_unique_id       i64
	position              types.Vector3
	particle_name         string
	molang_variables_json ?string
}

pub fn (p &SpawnParticleEffectPacket) pid() u16 {
	return spawn_particle_effect_packet
}

pub fn (p &SpawnParticleEffectPacket) name() string {
	return 'SpawnParticleEffectPacket'
}

pub fn (p &SpawnParticleEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SpawnParticleEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = int(r.u8()!)
	p.actor_unique_id = r.read_actor_unique_id()!
	p.position = r.read_vector3()!
	p.particle_name = r.read_string()!
	if r.bool()! {
		p.molang_variables_json = r.read_string()!
	} else {
		p.molang_variables_json = none
	}
}

pub fn (p &SpawnParticleEffectPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.dimension_id))
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_vector3(p.position)
	w.write_string(p.particle_name)
	if json := p.molang_variables_json {
		w.bool(true)
		w.write_string(json)
	} else {
		w.bool(false)
	}
}
