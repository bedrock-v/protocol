module packets

import protocol.serializer
import protocol.version.v291.types

pub struct LecternUpdatePacket {
pub mut:
	page           u8
	block_position types.BlockPosition
	dropping_book  bool
}

pub fn (p &LecternUpdatePacket) pid() u16 {
	return 124
}

pub fn (p &LecternUpdatePacket) name() string {
	return 'LecternUpdatePacket'
}

pub fn (p &LecternUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LecternUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.page)
	p.block_position.encode(mut w)
	w.bool(p.dropping_book)
}

pub fn (mut p LecternUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.page = r.u8()!
	p.block_position = types.BlockPosition.decode(mut r)!
	p.dropping_book = r.bool()!
}
