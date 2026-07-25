module packets

import serializer

pub struct KeepAlivePacket {
pub mut:
	payload i64
}

pub fn (p &KeepAlivePacket) pid() u16 {
	return 0x00
}

pub fn (p &KeepAlivePacket) name() string {
	return 'KeepAlivePacket'
}

pub fn (p &KeepAlivePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &KeepAlivePacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.payload)
}

pub fn (mut p KeepAlivePacket) decode_payload(mut r serializer.Reader) ! {
	p.payload = r.be_i64()!
}
