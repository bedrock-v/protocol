module src

import src.serializer

pub struct SetCommandsEnabledPacket {
pub mut:
	enabled bool
}

pub fn (p &SetCommandsEnabledPacket) pid() u16 {
	return set_commands_enabled_packet
}

pub fn (p &SetCommandsEnabledPacket) name() string {
	return 'SetCommandsEnabledPacket'
}

pub fn (p &SetCommandsEnabledPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetCommandsEnabledPacket) decode_payload(mut r serializer.Reader) ! {
	p.enabled = r.bool()!
}

pub fn (p &SetCommandsEnabledPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.enabled)
}
