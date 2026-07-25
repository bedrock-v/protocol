module packets

import serializer
import nbt

pub struct AvailableEntityIdentifiersPacket {
pub mut:
	identifiers nbt.RootTag
}

pub fn (p &AvailableEntityIdentifiersPacket) pid() u16 {
	return 119
}

pub fn (p &AvailableEntityIdentifiersPacket) name() string {
	return 'AvailableEntityIdentifiersPacket'
}

pub fn (p &AvailableEntityIdentifiersPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AvailableEntityIdentifiersPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.identifiers)
}

pub fn (mut p AvailableEntityIdentifiersPacket) decode_payload(mut r serializer.Reader) ! {
	p.identifiers = r.read_nbt_compound_root()!
}
