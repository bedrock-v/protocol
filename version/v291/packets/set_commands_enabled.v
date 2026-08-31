module packets

import protocol.serializer

pub struct SetCommandsEnabledPacket {
pub mut:
	commands_enabled bool
}

pub fn (p &SetCommandsEnabledPacket) pid() u16 {
	return 59
}

pub fn (p &SetCommandsEnabledPacket) name() string {
	return 'SetCommandsEnabledPacket'
}

pub fn (p &SetCommandsEnabledPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetCommandsEnabledPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.commands_enabled)
}

pub fn (mut p SetCommandsEnabledPacket) decode_payload(mut r serializer.Reader) ! {
	p.commands_enabled = r.bool()!
}
