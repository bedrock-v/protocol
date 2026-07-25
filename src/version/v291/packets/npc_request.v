module packets

import serializer

pub enum NpcRequestType as u8 {
	set_action               = 0
	execute_command_action   = 1
	execute_closing_commands = 2
	set_name                 = 3
	set_skin                 = 4
	set_interaction_text     = 5
	execute_opening_commands = 6
}

pub struct NpcRequestPacket {
pub mut:
	runtime_entity_id u64
	request_type      NpcRequestType
	command           string
	action_type       u8
}

pub fn (p &NpcRequestPacket) pid() u16 {
	return 98
}

pub fn (p &NpcRequestPacket) name() string {
	return 'NpcRequestPacket'
}

pub fn (p &NpcRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &NpcRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	w.u8(u8(p.request_type))
	w.write_string(p.command)
	w.u8(p.action_type)
}

pub fn (mut p NpcRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.request_type = unsafe { NpcRequestType(r.u8()!) }
	p.command = r.read_string()!
	p.action_type = r.u8()!
}
