module packets

import serializer

pub struct MoveEntityPacket {
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 0x90
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
}
