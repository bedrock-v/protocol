module src

import src.serializer

pub struct PlayStatusPacket {
pub mut:
	status int
}

pub fn (p &PlayStatusPacket) pid() u16 {
	return play_status_packet
}

pub fn (p &PlayStatusPacket) name() string {
	return 'PlayStatusPacket'
}

pub fn (p &PlayStatusPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p PlayStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.status = int(r.be_u32()!)
}

pub fn (p &PlayStatusPacket) encode_payload(mut w serializer.Writer) {
	w.be_u32(u32(p.status))
}
