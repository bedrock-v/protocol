module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SetLocalPlayerAsInitializedPacket {
pub mut:
	player_id types.ActorRuntimeID
}

pub fn (p &SetLocalPlayerAsInitializedPacket) pid() u16 {
	return 113
}

pub fn (p &SetLocalPlayerAsInitializedPacket) name() string {
	return 'SetLocalPlayerAsInitializedPacket'
}

pub fn (p &SetLocalPlayerAsInitializedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetLocalPlayerAsInitializedPacket) encode_payload(mut w serializer.Writer) {
	p.player_id.encode(mut w)
}

pub fn (mut p SetLocalPlayerAsInitializedPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_id = types.ActorRuntimeID.decode(mut r)!
}
