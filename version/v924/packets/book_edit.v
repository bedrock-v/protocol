module packets

import protocol.serializer
import protocol.version.v924.enums

pub struct BookEditPacket {
pub mut:
	book_slot i32
	action    enums.BookEditAction = enums.BookEditDeletePage{}
}

pub fn (p &BookEditPacket) pid() u16 {
	return 97
}

pub fn (p &BookEditPacket) name() string {
	return 'BookEditPacket'
}

pub fn (p &BookEditPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BookEditPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.book_slot)
	p.action.encode(mut w)
}

pub fn (mut p BookEditPacket) decode_payload(mut r serializer.Reader) ! {
	p.book_slot = r.read_varint32()!
	p.action = enums.BookEditAction.decode(mut r)!
}
