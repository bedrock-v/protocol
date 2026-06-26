module src

import src.serializer

pub struct MovementEffectPacket {
pub mut:
	actor_runtime_id u64
	effect_type      u32
	duration         u32
	tick             u64
}

pub fn (p &MovementEffectPacket) pid() u16 {
	return movement_effect_packet
}

pub fn (p &MovementEffectPacket) name() string {
	return 'MovementEffectPacket'
}

pub fn (p &MovementEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MovementEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.effect_type = r.read_varuint32()!
	p.duration = r.read_varuint32()!
	p.tick = r.read_varuint64()!
}

pub fn (p &MovementEffectPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_varuint32(p.effect_type)
	w.write_varuint32(p.duration)
	w.write_varuint64(p.tick)
}
