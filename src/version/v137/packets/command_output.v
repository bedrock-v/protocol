module packets

import serializer

pub struct CommandOutputPacket {
}

pub fn (p &CommandOutputPacket) pid() u16 {
	return 79
}

pub fn (p &CommandOutputPacket) name() string {
	return 'CommandOutputPacket'
}

pub fn (p &CommandOutputPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandOutputPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
}
