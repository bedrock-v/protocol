module packets

import protocol.serializer
import protocol.version.v662.types

pub struct BossEventPacket {
pub mut:
	target_actor_id types.ActorUniqueID
	event_type      types.BossEventUpdateType
}

pub fn (p &BossEventPacket) pid() u16 {
	return 74
}

pub fn (p &BossEventPacket) name() string {
	return 'BossEventPacket'
}

pub fn (p &BossEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BossEventPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	p.event_type.encode(mut w)
}

pub fn (mut p BossEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.event_type = types.BossEventUpdateType.decode(mut r)!
}
