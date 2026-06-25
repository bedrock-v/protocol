module src

import src.serializer
import src.types

pub struct SetActorMotionPacket {
pub mut:
	actor_runtime_id u64
	motion           types.Vector3
	tick             u64
}

pub fn (p &SetActorMotionPacket) pid() u16 {
	return set_actor_motion_packet
}

pub fn (p &SetActorMotionPacket) name() string {
	return 'SetActorMotionPacket'
}

pub fn (p &SetActorMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetActorMotionPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.motion = r.read_vector3()!
	p.tick = r.read_varuint64()!
}

pub fn (p &SetActorMotionPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_vector3(p.motion)
	w.write_varuint64(p.tick)
}
