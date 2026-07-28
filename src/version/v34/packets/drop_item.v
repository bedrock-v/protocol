module packets

import protocol.serializer
import protocol.version.v34.types

pub struct DropItemPacket {
pub mut:
	typ  u8
	item types.Item
}

pub fn (p &DropItemPacket) pid() u16 {
	return 0xb4
}

pub fn (p &DropItemPacket) name() string {
	return 'DropItemPacket'
}

pub fn (p &DropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DropItemPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.typ)
	p.item.encode(mut w)
}

pub fn (mut p DropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.typ = r.u8()!
	p.item = types.Item.decode(mut r)!
}
