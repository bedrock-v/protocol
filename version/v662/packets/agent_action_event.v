module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct AgentActionEventPacket {
pub mut:
	request_id  string
	action_type enums.AgentActionType
	response    string
}

pub fn (p &AgentActionEventPacket) pid() u16 {
	return 181
}

pub fn (p &AgentActionEventPacket) name() string {
	return 'AgentActionEventPacket'
}

pub fn (p &AgentActionEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AgentActionEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.request_id)
	p.action_type.encode(mut w)
	w.write_string(p.response)
}

pub fn (mut p AgentActionEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.request_id = r.read_string()!
	p.action_type = enums.AgentActionType.decode(mut r)!
	p.response = r.read_string()!
}
