module packets

import protocol.serializer

pub struct MobEffectPacket {
pub mut:
	entity_runtime_id u64
	event_id          u8
	effect_id         i32
	amplifier         i32
	particles         bool
	duration          i32
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
	w.write_varuint64(p.entity_runtime_id)
	w.u8(p.event_id)
	w.write_varint32(p.effect_id)
	w.write_varint32(p.amplifier)
	w.bool(p.particles)
	w.write_varint32(p.duration)
}

pub fn (mut p MobEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.event_id = r.u8()!
	p.effect_id = r.read_varint32()!
	p.amplifier = r.read_varint32()!
	p.particles = r.bool()!
	p.duration = r.read_varint32()!
}
