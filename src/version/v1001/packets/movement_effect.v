module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v1001.enums

pub struct MovementEffectPacket {
pub mut:
	entity_runtime_id types.ActorRuntimeID
	effect_type       enums.MovementEffectType
	duration          u32
	tick              u64
}

pub fn (p &MovementEffectPacket) pid() u16 {
	return 318
}

pub fn (p &MovementEffectPacket) name() string {
	return 'MovementEffectPacket'
}

pub fn (p &MovementEffectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MovementEffectPacket) encode_payload(mut w serializer.Writer) {
	p.entity_runtime_id.encode(mut w)
	p.effect_type.encode(mut w)
	w.write_varuint32(p.duration)
	w.write_varuint64(p.tick)
}

pub fn (mut p MovementEffectPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.effect_type = enums.MovementEffectType.decode(mut r)!
	p.duration = r.read_varuint32()!
	p.tick = r.read_varuint64()!
}
