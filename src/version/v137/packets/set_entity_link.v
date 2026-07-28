module packets

import protocol.serializer
import protocol.version.v137.types

pub struct SetEntityLinkPacket {
pub mut:
	link types.EntityLink
}

pub fn (p &SetEntityLinkPacket) pid() u16 {
	return 41
}

pub fn (p &SetEntityLinkPacket) name() string {
	return 'SetEntityLinkPacket'
}

pub fn (p &SetEntityLinkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityLinkPacket) encode_payload(mut w serializer.Writer) {
	p.link.encode(mut w)
}

pub fn (mut p SetEntityLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.link = types.EntityLink.decode(mut r)!
}
