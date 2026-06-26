module src

import src.serializer
import nbt

pub struct AvailableActorIdentifiersPacket {
pub mut:
	identifiers nbt.RootTag
}

pub fn (p &AvailableActorIdentifiersPacket) pid() u16 {
	return available_actor_identifiers_packet
}

pub fn (p &AvailableActorIdentifiersPacket) name() string {
	return 'AvailableActorIdentifiersPacket'
}

pub fn (p &AvailableActorIdentifiersPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AvailableActorIdentifiersPacket) decode_payload(mut r serializer.Reader) ! {
	p.identifiers = r.read_nbt_compound_root()!
}

pub fn (p &AvailableActorIdentifiersPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.identifiers)
}
