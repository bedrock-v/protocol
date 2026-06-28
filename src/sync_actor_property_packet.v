module protocol

import serializer
import nbt

pub struct SyncActorPropertyPacket {
pub mut:
	nbt nbt.RootTag
}

pub fn (p &SyncActorPropertyPacket) pid() u16 {
	return sync_actor_property_packet
}

pub fn (p &SyncActorPropertyPacket) name() string {
	return 'SyncActorPropertyPacket'
}

pub fn (p &SyncActorPropertyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SyncActorPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.nbt = r.read_nbt_compound_root()!
}

pub fn (p &SyncActorPropertyPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.nbt)
}
