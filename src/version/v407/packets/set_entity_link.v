module packets

import serializer
import version.v407.types

pub struct SetEntityLinkPacket {
pub mut:
	entity_link types.EntityLinkData
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
	p.entity_link.encode(mut w)
}

pub fn (mut p SetEntityLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_link = types.EntityLinkData.decode(mut r)!
}
