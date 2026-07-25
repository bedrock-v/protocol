module packets

import serializer

pub struct ServerToClientHandshakePacket {
pub mut:
	public_key   string
	server_token string
}

pub fn (p &ServerToClientHandshakePacket) pid() u16 {
	return 0x03
}

pub fn (p &ServerToClientHandshakePacket) name() string {
	return 'ServerToClientHandshakePacket'
}

pub fn (p &ServerToClientHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ServerToClientHandshakePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.public_key)
	w.write_string(p.server_token)
}

pub fn (mut p ServerToClientHandshakePacket) decode_payload(mut r serializer.Reader) ! {
	p.public_key = r.read_string()!
	p.server_token = r.read_string()!
}
