module packets

import serializer
import version.v113.types

pub struct AddItemPacket {
pub mut:
	item types.EraBItem
}

pub fn (p &AddItemPacket) pid() u16 {
	return 0x4b
}

pub fn (p &AddItemPacket) name() string {
	return 'AddItemPacket'
}

pub fn (p &AddItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemPacket) encode_payload(mut w serializer.Writer) {
	p.item.encode(mut w)
}

pub fn (mut p AddItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item = types.EraBItem.decode(mut r)!
}
