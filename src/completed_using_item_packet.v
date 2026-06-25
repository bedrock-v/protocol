module src

import src.serializer

pub struct CompletedUsingItemPacket {
pub mut:
	item_id int
	action  int
}

pub fn (p &CompletedUsingItemPacket) pid() u16 {
	return completed_using_item_packet
}

pub fn (p &CompletedUsingItemPacket) name() string {
	return 'CompletedUsingItemPacket'
}

pub fn (p &CompletedUsingItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CompletedUsingItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_id = int(r.le_i16()!)
	p.action = int(r.le_i32()!)
}

pub fn (p &CompletedUsingItemPacket) encode_payload(mut w serializer.Writer) {
	w.le_i16(i16(p.item_id))
	w.le_i32(i32(p.action))
}
