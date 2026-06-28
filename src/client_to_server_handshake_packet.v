module protocol

import serializer

pub struct ClientToServerHandshakePacket {
}

pub fn (p &ClientToServerHandshakePacket) pid() u16 {
	return client_to_server_handshake_packet
}

pub fn (p &ClientToServerHandshakePacket) name() string {
	return 'ClientToServerHandshakePacket'
}

pub fn (p &ClientToServerHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p ClientToServerHandshakePacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &ClientToServerHandshakePacket) encode_payload(mut w serializer.Writer) {
}
