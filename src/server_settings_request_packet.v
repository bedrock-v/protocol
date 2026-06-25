module src

import src.serializer

pub struct ServerSettingsRequestPacket {
}

pub fn (p &ServerSettingsRequestPacket) pid() u16 {
	return server_settings_request_packet
}

pub fn (p &ServerSettingsRequestPacket) name() string {
	return 'ServerSettingsRequestPacket'
}

pub fn (p &ServerSettingsRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerSettingsRequestPacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &ServerSettingsRequestPacket) encode_payload(mut w serializer.Writer) {
}
