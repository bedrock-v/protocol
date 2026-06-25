module src

import src.serializer

pub struct SetLocalPlayerAsInitializedPacket {
pub mut:
	actor_runtime_id u64
}

pub fn (p &SetLocalPlayerAsInitializedPacket) pid() u16 {
	return set_local_player_as_initialized_packet
}

pub fn (p &SetLocalPlayerAsInitializedPacket) name() string {
	return 'SetLocalPlayerAsInitializedPacket'
}

pub fn (p &SetLocalPlayerAsInitializedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetLocalPlayerAsInitializedPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
}

pub fn (p &SetLocalPlayerAsInitializedPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
}
