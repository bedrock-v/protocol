module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SetActorMotionPacket {
pub mut:
	target_runtime_id types.ActorRuntimeID
	motion            [3]f32
	server_tick       u64
}

pub fn (p &SetActorMotionPacket) pid() u16 {
	return 40
}

pub fn (p &SetActorMotionPacket) name() string {
	return 'SetActorMotionPacket'
}

pub fn (p &SetActorMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetActorMotionPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	w.le_f32(p.motion[0])
	w.le_f32(p.motion[1])
	w.le_f32(p.motion[2])
	w.write_varuint64(p.server_tick)
}

pub fn (mut p SetActorMotionPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.motion = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.server_tick = r.read_varuint64()!
}
