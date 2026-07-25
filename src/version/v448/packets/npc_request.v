module packets

import serializer
import version.v291.packets as packets_291

pub struct NpcRequestPacket {
pub mut:
	runtime_entity_id u64
	request_type      packets_291.NpcRequestType
	command           string
	action_type       u8
	scene_name        string
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
	w.write_string(p.scene_name)
}

pub fn (mut p NpcRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.request_type = unsafe { packets_291.NpcRequestType(r.u8()!) }
	p.command = r.read_string()!
	p.action_type = r.u8()!
	p.scene_name = r.read_string()!
}
