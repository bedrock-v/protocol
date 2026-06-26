module src

import src.serializer

pub struct AgentActionEventPacket {
pub mut:
	request_id    string
	action        u32
	response_json string
}

pub fn (p &AgentActionEventPacket) pid() u16 {
	return agent_action_event_packet
}

pub fn (p &AgentActionEventPacket) name() string {
	return 'AgentActionEventPacket'
}

pub fn (p &AgentActionEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AgentActionEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.request_id = r.read_string()!
	p.action = r.le_u32()!
	p.response_json = r.read_string()!
}

pub fn (p &AgentActionEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.request_id)
	w.le_u32(p.action)
	w.write_string(p.response_json)
}
