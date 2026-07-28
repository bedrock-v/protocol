module packets

import protocol.serializer
import nbt

pub struct SyncActorPropertyPacket {
pub mut:
	property_data nbt.RootTag
}

pub fn (p &SyncActorPropertyPacket) pid() u16 {
	return 165
}

pub fn (p &SyncActorPropertyPacket) name() string {
	return 'SyncActorPropertyPacket'
}

pub fn (p &SyncActorPropertyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SyncActorPropertyPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.property_data)
}

pub fn (mut p SyncActorPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.property_data = r.read_nbt_compound_root()!
}
