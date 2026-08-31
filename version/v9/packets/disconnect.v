module packets

import protocol.serializer

pub struct DisconnectPacket {
}

pub fn (p &DisconnectPacket) pid() u16 {
	return 0x15
}

pub fn (p &DisconnectPacket) name() string {
	return 'DisconnectPacket'
}

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
}
