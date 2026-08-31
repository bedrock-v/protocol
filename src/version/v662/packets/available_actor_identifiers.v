module packets

import protocol.serializer
import bedrock_v.nbt

pub struct AvailableActorIdentifiersPacket {
pub mut:
	actor_info_list nbt.RootTag
}

pub fn (p &AvailableActorIdentifiersPacket) pid() u16 {
	return 119
}

pub fn (p &AvailableActorIdentifiersPacket) name() string {
	return 'AvailableActorIdentifiersPacket'
}

pub fn (p &AvailableActorIdentifiersPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AvailableActorIdentifiersPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.actor_info_list)
}

pub fn (mut p AvailableActorIdentifiersPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_info_list = r.read_nbt_compound_root()!
}
