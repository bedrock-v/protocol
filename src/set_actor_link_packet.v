module src

import src.serializer
import src.types

pub struct SetActorLinkPacket {
pub mut:
	link types.EntityLink
}

pub fn (p &SetActorLinkPacket) pid() u16 {
	return set_actor_link_packet
}

pub fn (p &SetActorLinkPacket) name() string {
	return 'SetActorLinkPacket'
}

pub fn (p &SetActorLinkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetActorLinkPacket) decode_payload(mut r serializer.Reader) ! {
	p.link = r.read_entity_link()!
}

pub fn (p &SetActorLinkPacket) encode_payload(mut w serializer.Writer) {
	w.write_entity_link(p.link)
}
