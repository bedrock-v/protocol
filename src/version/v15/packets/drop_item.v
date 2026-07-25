module packets

import serializer
import version.v14.types

pub struct DropItemPacket {
pub mut:
	eid     i32
	unknown u8
	item    types.OldItem
}

pub fn (p &DropItemPacket) pid() u16 {
	return 0xaf
}

pub fn (p &DropItemPacket) name() string {
	return 'DropItemPacket'
}

pub fn (p &DropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DropItemPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.unknown)
	p.item.encode(mut w)
}

pub fn (mut p DropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.unknown = r.u8()!
	p.item = types.OldItem.decode(mut r)!
}
