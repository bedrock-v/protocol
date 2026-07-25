module packets

import serializer

pub enum AgentActionType as i32 {
	@none               = 0
	attack              = 1
	collect             = 2
	destroy             = 3
	detect_redstone     = 4
	detect_obstacle     = 5
	drop                = 6
	drop_all            = 7
	inspect             = 8
	inspect_data        = 9
	inspect_item_count  = 10
	inspect_item_detail = 11
	inspect_item_space  = 12
	interact            = 13
	move                = 14
	place_block         = 15
	till                = 16
	transfer_item_to    = 17
	turn                = 18
}

pub struct AgentActionEventPacket {
pub mut:
	request_id    string
	action_type   AgentActionType
	response_json string
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
	w.le_i32(i32(p.action_type))
	w.write_string(p.response_json)
}

pub fn (mut p AgentActionEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.request_id = r.read_string()!
	p.action_type = unsafe { AgentActionType(r.le_i32()!) }
	p.response_json = r.read_string()!
}
