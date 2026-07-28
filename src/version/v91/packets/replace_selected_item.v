module packets

import protocol.serializer
import protocol.version.v91.types

pub struct ReplaceSelectedItemPacket {
pub mut:
	item types.EraBItem
}

pub fn (p &ReplaceSelectedItemPacket) pid() u16 {
	return 0x46
}

pub fn (p &ReplaceSelectedItemPacket) name() string {
	return 'ReplaceSelectedItemPacket'
}

pub fn (p &ReplaceSelectedItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ReplaceSelectedItemPacket) encode_payload(mut w serializer.Writer) {
	p.item.encode(mut w)
}

pub fn (mut p ReplaceSelectedItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item = types.EraBItem.decode(mut r)!
}
