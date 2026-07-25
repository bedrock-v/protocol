module packets

import serializer

pub struct PlayStatusPacket {
pub mut:
	status i32
}

pub fn (p &PlayStatusPacket) pid() u16 {
	return 0x02
}

pub fn (p &PlayStatusPacket) name() string {
	return 'PlayStatusPacket'
}

pub fn (p &PlayStatusPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &PlayStatusPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.status)
}

pub fn (mut p PlayStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.status = r.be_i32()!
}
