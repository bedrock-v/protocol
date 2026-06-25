module src

import src.serializer
import src.types

pub struct LecternUpdatePacket {
pub mut:
	page           int
	total_pages    int
	block_position types.BlockPosition
}

pub fn (p &LecternUpdatePacket) pid() u16 {
	return lectern_update_packet
}

pub fn (p &LecternUpdatePacket) name() string {
	return 'LecternUpdatePacket'
}

pub fn (p &LecternUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LecternUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.page = int(r.u8()!)
	p.total_pages = int(r.u8()!)
	p.block_position = r.read_block_position()!
}

pub fn (p &LecternUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.page))
	w.u8(u8(p.total_pages))
	w.write_block_position(p.block_position)
}
