module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct SetLastHurtByPacket {
pub mut:
	last_hurt_by enums.ActorType
}

pub fn (p &SetLastHurtByPacket) pid() u16 {
	return 96
}

pub fn (p &SetLastHurtByPacket) name() string {
	return 'SetLastHurtByPacket'
}

pub fn (p &SetLastHurtByPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetLastHurtByPacket) encode_payload(mut w serializer.Writer) {
	p.last_hurt_by.encode(mut w)
}

pub fn (mut p SetLastHurtByPacket) decode_payload(mut r serializer.Reader) ! {
	p.last_hurt_by = enums.ActorType.decode(mut r)!
}
