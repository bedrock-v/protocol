module packets

import serializer
import version.v712.types

pub struct SetActorLinkPacket {
pub mut:
	link types.ActorLink
}

pub fn (p &SetActorLinkPacket) pid() u16 { return 41 }

pub fn (p &SetActorLinkPacket) name() string { return 'SetActorLinkPacket' }

pub fn (p &SetActorLinkPacket) can_be_sent_before_login() bool { return false }

pub fn (p &SetActorLinkPacket) encode_payload(mut w serializer.Writer) {
	p.link.encode(mut w)
}

pub fn (mut p SetActorLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.link = types.ActorLink.decode(mut r)!
}
