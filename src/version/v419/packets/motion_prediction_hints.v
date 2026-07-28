module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct MotionPredictionHintsPacket {
pub mut:
	runtime_entity_id u64
	motion            types_291.Vector3f
	on_ground         bool
}

pub fn (p &MotionPredictionHintsPacket) pid() u16 {
	return 157
}

pub fn (p &MotionPredictionHintsPacket) name() string {
	return 'MotionPredictionHintsPacket'
}

pub fn (p &MotionPredictionHintsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MotionPredictionHintsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	p.motion.encode(mut w)
	w.bool(p.on_ground)
}

pub fn (mut p MotionPredictionHintsPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.motion = types_291.Vector3f.decode(mut r)!
	p.on_ground = r.bool()!
}
