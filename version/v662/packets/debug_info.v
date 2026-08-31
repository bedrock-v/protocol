module packets

import protocol.serializer
import protocol.version.v662.types

pub struct DebugInfoPacket {
pub mut:
	actor_id types.ActorUniqueID
	data     []u8
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
	p.actor_id.encode(mut w)
	w.write_string_bytes(p.data)
}

pub fn (mut p DebugInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_id = types.ActorUniqueID.decode(mut r)!
	p.data = r.read_string_bytes()!
}
