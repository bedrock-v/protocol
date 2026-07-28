module packets

import protocol.serializer

pub enum MobEffectEvent as u8 {
	@none  = 0
	add    = 1
	modify = 2
	remove = 3
}

pub struct MobEffectPacket {
pub mut:
	runtime_entity_id u64
	event             MobEffectEvent
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
	w.write_varuint64(p.runtime_entity_id)
	w.u8(u8(p.event))
	w.write_varint32(p.effect_id)
	w.write_varint32(p.amplifier)
	w.bool(p.particles)
	w.write_varint32(p.duration)
}

pub fn (mut p MobEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.event = unsafe { MobEffectEvent(r.u8()!) }
	p.effect_id = r.read_varint32()!
	p.amplifier = r.read_varint32()!
	p.particles = r.bool()!
	p.duration = r.read_varint32()!
}
