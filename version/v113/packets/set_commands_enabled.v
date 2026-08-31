module packets

import protocol.serializer

pub struct SetCommandsEnabledPacket {
pub mut:
	enabled bool
}

pub fn (p &SetCommandsEnabledPacket) pid() u16 {
	return 0x3b
}

pub fn (p &SetCommandsEnabledPacket) name() string {
	return 'SetCommandsEnabledPacket'
}

pub fn (p &SetCommandsEnabledPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetCommandsEnabledPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.enabled)
}

pub fn (mut p SetCommandsEnabledPacket) decode_payload(mut r serializer.Reader) ! {
	p.enabled = r.bool()!
}
