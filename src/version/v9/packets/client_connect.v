module packets

import serializer

pub struct ClientConnectPacket {
pub mut:
	client_id i64
	session   i64
	unknown2  u8
}

pub fn (p &ClientConnectPacket) pid() u16 {
	return 0x09
}

pub fn (p &ClientConnectPacket) name() string {
	return 'ClientConnectPacket'
}

pub fn (p &ClientConnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ClientConnectPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.client_id)
	w.be_i64(p.session)
	w.u8(0x00)
}

pub fn (mut p ClientConnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_id = r.be_i64()!
	p.session = r.be_i64()!
	p.unknown2 = r.u8()!
}
