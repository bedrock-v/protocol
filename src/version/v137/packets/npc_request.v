module packets

import serializer

pub struct NpcRequestPacket {
pub mut:
	entity_runtime_id u64
	request_type      u8
	command_string    string
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
	w.write_varuint64(p.entity_runtime_id)
	w.u8(p.request_type)
	w.write_string(p.command_string)
	w.u8(p.action_type)
}

pub fn (mut p NpcRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.request_type = r.u8()!
	p.command_string = r.read_string()!
	p.action_type = r.u8()!
}
