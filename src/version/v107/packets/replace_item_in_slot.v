module packets

import serializer
import version.v107.types

pub struct ReplaceItemInSlotPacket {
pub mut:
	item types.EraBItem
}

pub fn (p &ReplaceItemInSlotPacket) pid() u16 {
	return 0x48
}

pub fn (p &ReplaceItemInSlotPacket) name() string {
	return 'ReplaceItemInSlotPacket'
}

pub fn (p &ReplaceItemInSlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ReplaceItemInSlotPacket) encode_payload(mut w serializer.Writer) {
	p.item.encode(mut w)
}

pub fn (mut p ReplaceItemInSlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.item = types.EraBItem.decode(mut r)!
}
