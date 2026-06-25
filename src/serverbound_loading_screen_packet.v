module src

import src.serializer

pub struct ServerboundLoadingScreenPacket {
pub mut:
	loading_screen_type int
	loading_screen_id   ?u32
}

pub fn (p &ServerboundLoadingScreenPacket) pid() u16 {
	return serverbound_loading_screen_packet
}

pub fn (p &ServerboundLoadingScreenPacket) name() string {
	return 'ServerboundLoadingScreenPacket'
}

pub fn (p &ServerboundLoadingScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerboundLoadingScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.loading_screen_type = int(r.read_varint32()!)
	if r.bool()! {
		p.loading_screen_id = r.le_u32()!
	} else {
		p.loading_screen_id = none
	}
}

pub fn (p &ServerboundLoadingScreenPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.loading_screen_type))
	if id := p.loading_screen_id {
		w.bool(true)
		w.le_u32(id)
	} else {
		w.bool(false)
	}
}
