module packets

import protocol.serializer
import protocol.version.v662.types

pub struct TakeItemActorPacket {
pub mut:
	item_runtime_id  types.ActorRuntimeID
	actor_runtime_id types.ActorRuntimeID
}

pub fn (p &TakeItemActorPacket) pid() u16 {
	return 17
}

pub fn (p &TakeItemActorPacket) name() string {
	return 'TakeItemActorPacket'
}

pub fn (p &TakeItemActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TakeItemActorPacket) encode_payload(mut w serializer.Writer) {
	p.item_runtime_id.encode(mut w)
	p.actor_runtime_id.encode(mut w)
}

pub fn (mut p TakeItemActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.actor_runtime_id = types.ActorRuntimeID.decode(mut r)!
}
