module packets

import serializer

pub struct SetCommandsEnabledPacket {
pub mut:
	enabled bool
}

pub fn (p &SetCommandsEnabledPacket) pid() u16 {
	return 0x3c
}

pub fn (p &SetCommandsEnabledPacket) name() string {
	return 'SetCommandsEnabledPacket'
}

pub fn (p &SetCommandsEnabledPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetCommandsEnabledPacket) encode_payload(mut w serializer.Writer) {
	w.u8(if p.enabled { u8(1) } else { u8(0) })
}

pub fn (mut p SetCommandsEnabledPacket) decode_payload(mut r serializer.Reader) ! {
	p.enabled = r.u8()! > 0
}
