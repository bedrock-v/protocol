module packets

import serializer
import version.v662.types

pub struct RemoveActorPacket {
pub mut:
	target_actor_id types.ActorUniqueID
}

pub fn (p &RemoveActorPacket) pid() u16 { return 14 }

pub fn (p &RemoveActorPacket) name() string { return 'RemoveActorPacket' }

pub fn (p &RemoveActorPacket) can_be_sent_before_login() bool { return false }

pub fn (p &RemoveActorPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
}

pub fn (mut p RemoveActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
}
