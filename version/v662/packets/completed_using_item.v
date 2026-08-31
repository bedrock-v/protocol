module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct CompletedUsingItemPacket {
pub mut:
	item_id         u16
	item_use_method enums.ItemUseMethod
}

pub fn (p &CompletedUsingItemPacket) pid() u16 {
	return 142
}

pub fn (p &CompletedUsingItemPacket) name() string {
	return 'CompletedUsingItemPacket'
}

pub fn (p &CompletedUsingItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CompletedUsingItemPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(p.item_id)
	p.item_use_method.encode(mut w)
}

pub fn (mut p CompletedUsingItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_id = r.le_u16()!
	p.item_use_method = enums.ItemUseMethod.decode(mut r)!
}
