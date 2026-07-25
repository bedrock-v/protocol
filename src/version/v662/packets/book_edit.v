module packets

import serializer
import version.v662.enums

pub struct BookEditPacket {
pub mut:
	action    enums.BookEditAction = enums.BookEditDeletePage{}
	book_slot i8
}

pub fn (p &BookEditPacket) pid() u16 { return 97 }

pub fn (p &BookEditPacket) name() string { return 'BookEditPacket' }

pub fn (p &BookEditPacket) can_be_sent_before_login() bool { return false }

pub fn (p &BookEditPacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.action.id())
	w.i8(p.book_slot)
	p.action.encode_payload(mut w)
}

pub fn (mut p BookEditPacket) decode_payload(mut r serializer.Reader) ! {
	action_id := r.i8()!
	p.book_slot = r.i8()!
	p.action = enums.BookEditAction.decode_payload(action_id, mut r)!
}
