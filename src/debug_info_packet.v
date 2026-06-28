module protocol

import serializer

pub struct DebugInfoPacket {
pub mut:
	actor_unique_id i64
	data            string
}

pub fn (p &DebugInfoPacket) pid() u16 {
	return debug_info_packet
}

pub fn (p &DebugInfoPacket) name() string {
	return 'DebugInfoPacket'
}

pub fn (p &DebugInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p DebugInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
	p.data = r.read_string()!
}

pub fn (p &DebugInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_string(p.data)
}
