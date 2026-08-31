module packets

import protocol.serializer

pub struct DebugInfoPacket {
pub mut:
	unique_entity_id i64
	data             string
}

pub fn (p &DebugInfoPacket) pid() u16 {
	return 155
}

pub fn (p &DebugInfoPacket) name() string {
	return 'DebugInfoPacket'
}

pub fn (p &DebugInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DebugInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.unique_entity_id)
	w.write_string(p.data)
}

pub fn (mut p DebugInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.data = r.read_string()!
}
