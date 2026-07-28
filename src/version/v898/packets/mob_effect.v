module packets

import protocol.serializer
import protocol.version.v662.types

pub enum MobEffectEvent as i8 {
	invalid = 0
	add     = 1
	update  = 2
	remove  = 3
}

pub struct MobEffectPacket {
pub mut:
	target_runtime_id     types.ActorRuntimeID
	event_id              MobEffectEvent
	effect_id             i32
	effect_amplifier      i32
	show_particles        bool
	effect_duration_ticks i32
	tick                  u64
	ambient               bool
}

pub fn (p &MobEffectPacket) pid() u16 {
	return 28
}

pub fn (p &MobEffectPacket) name() string {
	return 'MobEffectPacket'
}

pub fn (p &MobEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobEffectPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	w.i8(i8(p.event_id))
	w.write_varint32(p.effect_id)
	w.write_varint32(p.effect_amplifier)
	w.bool(p.show_particles)
	w.write_varint32(p.effect_duration_ticks)
	w.write_varuint64(p.tick)
	w.bool(p.ambient)
}

pub fn (mut p MobEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.event_id = unsafe { MobEffectEvent(r.i8()!) }
	p.effect_id = r.read_varint32()!
	p.effect_amplifier = r.read_varint32()!
	p.show_particles = r.bool()!
	p.effect_duration_ticks = r.read_varint32()!
	p.tick = r.read_varuint64()!
	p.ambient = r.bool()!
}
