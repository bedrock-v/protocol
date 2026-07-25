module packets

import nbt
import serializer

pub struct SyncEntityPropertyPacket {
pub mut:
	data nbt.RootTag
}

pub fn (p &SyncEntityPropertyPacket) pid() u16 {
	return 165
}

pub fn (p &SyncEntityPropertyPacket) name() string {
	return 'SyncEntityPropertyPacket'
}

pub fn (p &SyncEntityPropertyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SyncEntityPropertyPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.data)
}

pub fn (mut p SyncEntityPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = r.read_nbt_compound_root()!
}
