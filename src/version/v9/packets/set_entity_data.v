module packets

import serializer
import version.v14.types as types_14

pub struct SetEntityDataPacket {
pub mut:
	eid i32
}

pub fn (p &SetEntityDataPacket) pid() u16 {
	return 0xa3
}

pub fn (p &SetEntityDataPacket) name() string {
	return 'SetEntityDataPacket'
}

pub fn (p &SetEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	empty := types_14.OldMetadata{}
	empty.encode(mut w)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
}
