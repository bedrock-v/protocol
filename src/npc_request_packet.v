module src

import src.serializer

pub struct NpcRequestPacket {
pub mut:
	actor_runtime_id u64
	request_type     int
	command_string   string
	action_index     int
	scene_name       string
}

pub fn (p &NpcRequestPacket) pid() u16 {
	return npc_request_packet
}

pub fn (p &NpcRequestPacket) name() string {
	return 'NpcRequestPacket'
}

pub fn (p &NpcRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p NpcRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.request_type = int(r.u8()!)
	p.command_string = r.read_string()!
	p.action_index = int(r.u8()!)
	p.scene_name = r.read_string()!
}

pub fn (p &NpcRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.u8(u8(p.request_type))
	w.write_string(p.command_string)
	w.u8(u8(p.action_index))
	w.write_string(p.scene_name)
}
