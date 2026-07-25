module packets

import serializer
import version.v662.types

pub struct AgentAnimationPacket {
pub mut:
	agent_animation i8
	runtime_id      types.ActorRuntimeID
}

pub fn (p &AgentAnimationPacket) pid() u16 { return 304 }

pub fn (p &AgentAnimationPacket) name() string { return 'AgentAnimationPacket' }

pub fn (p &AgentAnimationPacket) can_be_sent_before_login() bool { return false }

pub fn (p &AgentAnimationPacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.agent_animation)
	p.runtime_id.encode(mut w)
}

pub fn (mut p AgentAnimationPacket) decode_payload(mut r serializer.Reader) ! {
	p.agent_animation = r.i8()!
	p.runtime_id = types.ActorRuntimeID.decode(mut r)!
}
