module packets

import serializer

pub struct InteractPacket {
pub mut:
	action u8
	target i64
}

pub fn (p &InteractPacket) pid() u16 {
	return 0x1f
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action)
	w.be_i64(p.target)
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.u8()!
	p.target = r.be_i64()!
}
