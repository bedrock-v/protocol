module packets

import serializer
import version.v34.types

pub struct SetEntityDataPacket {
pub mut:
	eid      i64
	metadata types.OldMetadata
}

pub fn (p &SetEntityDataPacket) pid() u16 {
	return 0x22
}

pub fn (p &SetEntityDataPacket) name() string {
	return 'SetEntityDataPacket'
}

pub fn (p &SetEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	p.metadata.encode(mut w)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.metadata = types.OldMetadata.decode(mut r)!
}
