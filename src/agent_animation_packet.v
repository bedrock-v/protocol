module protocol

import serializer

pub struct AgentAnimationPacket {
pub mut:
	animation_type   int
	actor_runtime_id u64
}

pub fn (p &AgentAnimationPacket) pid() u16 {
	return agent_animation_packet
}

pub fn (p &AgentAnimationPacket) name() string {
	return 'AgentAnimationPacket'
}

pub fn (p &AgentAnimationPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AgentAnimationPacket) decode_payload(mut r serializer.Reader) ! {
	p.animation_type = int(r.u8()!)
	p.actor_runtime_id = r.read_actor_runtime_id()!
}

pub fn (p &AgentAnimationPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.animation_type))
	w.write_actor_runtime_id(p.actor_runtime_id)
}
