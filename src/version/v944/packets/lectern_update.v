module packets

import serializer
import version.v944.types

pub struct LecternUpdatePacket {
pub mut:
	new_page_to_show              i8
	total_pages                   i8
	position_of_lectern_to_update types.NetworkBlockPosition
}

pub fn (p &LecternUpdatePacket) pid() u16 { return 125 }

pub fn (p &LecternUpdatePacket) name() string { return 'LecternUpdatePacket' }

pub fn (p &LecternUpdatePacket) can_be_sent_before_login() bool { return false }

pub fn (p &LecternUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.new_page_to_show)
	w.i8(p.total_pages)
	p.position_of_lectern_to_update.encode(mut w)
}

pub fn (mut p LecternUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.new_page_to_show = r.i8()!
	p.total_pages = r.i8()!
	p.position_of_lectern_to_update = types.NetworkBlockPosition.decode(mut r)!
}
