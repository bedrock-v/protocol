module packets

import serializer

pub struct AgentAnimationPacket {
pub mut:
	animation         i8
	runtime_entity_id u64
}

pub fn (p &AgentAnimationPacket) pid() u16 {
	return 304
}

pub fn (p &AgentAnimationPacket) name() string {
	return 'AgentAnimationPacket'
}

pub fn (p &AgentAnimationPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AgentAnimationPacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.animation)
	w.write_varuint64(p.runtime_entity_id)
}

pub fn (mut p AgentAnimationPacket) decode_payload(mut r serializer.Reader) ! {
	p.animation = r.i8()!
	p.runtime_entity_id = r.read_varuint64()!
}
