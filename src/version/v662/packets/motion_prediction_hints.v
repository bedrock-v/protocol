module packets

import protocol.serializer
import protocol.version.v662.types

pub struct MotionPredictionHintsPacket {
pub mut:
	runtime_id types.ActorRuntimeID
	motion     [3]f32
	on_ground  bool
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
	p.runtime_id.encode(mut w)
	w.le_f32(p.motion[0])
	w.le_f32(p.motion[1])
	w.le_f32(p.motion[2])
	w.bool(p.on_ground)
}

pub fn (mut p MotionPredictionHintsPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.motion = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.on_ground = r.bool()!
}
