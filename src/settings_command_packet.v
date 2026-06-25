module src

import src.serializer

pub struct SettingsCommandPacket {
pub mut:
	command         string
	suppress_output bool
}

pub fn (p &SettingsCommandPacket) pid() u16 {
	return settings_command_packet
}

pub fn (p &SettingsCommandPacket) name() string {
	return 'SettingsCommandPacket'
}

pub fn (p &SettingsCommandPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SettingsCommandPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.suppress_output = r.bool()!
}

pub fn (p &SettingsCommandPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	w.bool(p.suppress_output)
}
