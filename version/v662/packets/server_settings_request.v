module packets

import protocol.serializer

pub struct ServerSettingsRequestPacket {}

pub fn (p &ServerSettingsRequestPacket) pid() u16 {
	return 102
}

pub fn (p &ServerSettingsRequestPacket) name() string {
	return 'ServerSettingsRequestPacket'
}

pub fn (p &ServerSettingsRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerSettingsRequestPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ServerSettingsRequestPacket) decode_payload(mut r serializer.Reader) ! {
}
