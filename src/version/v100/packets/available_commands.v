module packets

import serializer

pub struct AvailableCommandsPacket {
pub mut:
	commands string
	unknown  string
}

pub fn (p &AvailableCommandsPacket) pid() u16 {
	return 0x4d
}

pub fn (p &AvailableCommandsPacket) name() string {
	return 'AvailableCommandsPacket'
}

pub fn (p &AvailableCommandsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AvailableCommandsPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.commands)
	w.write_string(p.unknown)
}

pub fn (mut p AvailableCommandsPacket) decode_payload(mut r serializer.Reader) ! {
	p.commands = r.read_string()!
	p.unknown = r.read_string()!
}
