module packets

import protocol.serializer

pub struct ServerSettingsResponsePacket {}

pub fn (p &ServerSettingsResponsePacket) pid() u16 {
	return 103
}

pub fn (p &ServerSettingsResponsePacket) name() string {
	return 'ServerSettingsResponsePacket'
}

pub fn (p &ServerSettingsResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerSettingsResponsePacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ServerSettingsResponsePacket) decode_payload(mut r serializer.Reader) ! {
}
