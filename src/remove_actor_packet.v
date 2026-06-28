module protocol

import serializer

pub struct RemoveActorPacket {
pub mut:
	actor_unique_id i64
}

pub fn (p &RemoveActorPacket) pid() u16 {
	return remove_actor_packet
}

pub fn (p &RemoveActorPacket) name() string {
	return 'RemoveActorPacket'
}

pub fn (p &RemoveActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RemoveActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
}

pub fn (p &RemoveActorPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
}
