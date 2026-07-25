module packets

import serializer

pub struct ClientToServerHandshakePacket {
}

pub fn (p &ClientToServerHandshakePacket) pid() u16 {
	return 0x04
}

pub fn (p &ClientToServerHandshakePacket) name() string {
	return 'ClientToServerHandshakePacket'
}

pub fn (p &ClientToServerHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ClientToServerHandshakePacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ClientToServerHandshakePacket) decode_payload(mut r serializer.Reader) ! {
}
