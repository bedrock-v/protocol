module packets

import serializer

pub struct MobEffectPacket {
pub mut:
	eid       i64
	event_id  u8
	effect_id u8
	amplifier u8
	particles bool
	duration  i32
}

pub fn (p &MobEffectPacket) pid() u16 {
	return 0x1b
}

pub fn (p &MobEffectPacket) name() string {
	return 'MobEffectPacket'
}

pub fn (p &MobEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobEffectPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.u8(p.event_id)
	w.u8(p.effect_id)
	w.u8(p.amplifier)
	w.u8(if p.particles { u8(1) } else { u8(0) })
	w.be_i32(p.duration)
}

pub fn (mut p MobEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.event_id = r.u8()!
	p.effect_id = r.u8()!
	p.amplifier = r.u8()!
	p.particles = r.u8()! > 0
	p.duration = r.be_i32()!
}
