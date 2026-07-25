module packets

import serializer

pub struct ServerToClientHandshakePacket {
pub mut:
	jwt string
}

pub fn (p &ServerToClientHandshakePacket) pid() u16 {
	return 3
}

pub fn (p &ServerToClientHandshakePacket) name() string {
	return 'ServerToClientHandshakePacket'
}

pub fn (p &ServerToClientHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ServerToClientHandshakePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.jwt)
}

pub fn (mut p ServerToClientHandshakePacket) decode_payload(mut r serializer.Reader) ! {
	p.jwt = r.read_string()!
}
