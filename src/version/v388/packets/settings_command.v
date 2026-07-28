module packets

import protocol.serializer

pub struct SettingsCommandPacket {
pub mut:
	command            string
	suppressing_output bool
}

pub fn (p &SettingsCommandPacket) pid() u16 {
	return 140
}

pub fn (p &SettingsCommandPacket) name() string {
	return 'SettingsCommandPacket'
}

pub fn (p &SettingsCommandPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SettingsCommandPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	w.bool(p.suppressing_output)
}

pub fn (mut p SettingsCommandPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.suppressing_output = r.bool()!
}
