module src

import src.serializer
import src.types

pub struct MotionPredictionHintsPacket {
pub mut:
	actor_runtime_id u64
	motion           types.Vector3
	on_ground        bool
}

pub fn (p &MotionPredictionHintsPacket) pid() u16 {
	return motion_prediction_hints_packet
}

pub fn (p &MotionPredictionHintsPacket) name() string {
	return 'MotionPredictionHintsPacket'
}

pub fn (p &MotionPredictionHintsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MotionPredictionHintsPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.motion = r.read_vector3()!
	p.on_ground = r.bool()!
}

pub fn (p &MotionPredictionHintsPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_vector3(p.motion)
	w.bool(p.on_ground)
}
