module packets

import serializer

pub struct DisconnectPacket {
pub mut:
	message string
}

pub fn (p &DisconnectPacket) pid() u16 {
	return 0x05
}

pub fn (p &DisconnectPacket) name() string {
	return 'DisconnectPacket'
}

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.message)
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.message = r.read_string()!
}
