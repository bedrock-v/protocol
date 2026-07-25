module packets

import serializer

pub struct SimpleEventPacket {
pub mut:
	unknown_short1 i16
}

pub fn (p &SimpleEventPacket) pid() u16 {
	return 64
}

pub fn (p &SimpleEventPacket) name() string {
	return 'SimpleEventPacket'
}

pub fn (p &SimpleEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SimpleEventPacket) encode_payload(mut w serializer.Writer) {
	w.le_i16(p.unknown_short1)
}

pub fn (mut p SimpleEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown_short1 = r.le_i16()!
}
