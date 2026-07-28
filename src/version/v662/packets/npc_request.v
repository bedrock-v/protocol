module packets

import protocol.serializer
import protocol.version.v662.types

pub enum NpcRequestType as i8 {
	set_actions              = 0
	execute_action           = 1
	execute_closing_commands = 2
	set_name                 = 3
	set_skin                 = 4
	set_interact_text        = 5
	execute_opening_commands = 6
}

pub struct NpcRequestPacket {
pub mut:
	npc_runtime_id types.ActorRuntimeID
	request_type   NpcRequestType
	actions        string
	action_index   i8
	scene_name     string
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
	p.npc_runtime_id.encode(mut w)
	w.i8(i8(p.request_type))
	w.write_string(p.actions)
	w.i8(p.action_index)
	w.write_string(p.scene_name)
}

pub fn (mut p NpcRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.npc_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.request_type = unsafe { NpcRequestType(r.i8()!) }
	p.actions = r.read_string()!
	p.action_index = r.i8()!
	p.scene_name = r.read_string()!
}
