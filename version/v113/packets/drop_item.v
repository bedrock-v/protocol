module packets

import protocol.serializer
import protocol.version.v113.types

pub struct DropItemPacket {
pub mut:
	type u8
	item types.EraBItem
}

pub fn (p &DropItemPacket) pid() u16 {
	return 0x2e
}

pub fn (p &DropItemPacket) name() string {
	return 'DropItemPacket'
}

pub fn (p &DropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DropItemPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.type)
	p.item.encode(mut w)
}

pub fn (mut p DropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	p.item = types.EraBItem.decode(mut r)!
}
