module src

import src.serializer

pub struct MobEffectPacket {
pub mut:
	actor_runtime_id u64
	event_id         int
	effect_id        int
	amplifier        int
	particles        bool
	duration         int
	tick             u64
	ambient          bool
}

pub fn (p &MobEffectPacket) pid() u16 {
	return mob_effect_packet
}

pub fn (p &MobEffectPacket) name() string {
	return 'MobEffectPacket'
}

pub fn (p &MobEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MobEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.event_id = int(r.u8()!)
	p.effect_id = int(r.read_varint32()!)
	p.amplifier = int(r.read_varint32()!)
	p.particles = r.bool()!
	p.duration = int(r.read_varint32()!)
	p.tick = r.read_varuint64()!
	p.ambient = r.bool()!
}

pub fn (p &MobEffectPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.u8(u8(p.event_id))
	w.write_varint32(i32(p.effect_id))
	w.write_varint32(i32(p.amplifier))
	w.bool(p.particles)
	w.write_varint32(i32(p.duration))
	w.write_varuint64(p.tick)
	w.bool(p.ambient)
}
