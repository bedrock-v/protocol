module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct MultiplayerSettingsPacket {
pub mut:
	multiplayer_settings_packet_type enums.MultiplayerSettingsPacketType
}

pub fn (p &MultiplayerSettingsPacket) pid() u16 {
	return 139
}

pub fn (p &MultiplayerSettingsPacket) name() string {
	return 'MultiplayerSettingsPacket'
}

pub fn (p &MultiplayerSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MultiplayerSettingsPacket) encode_payload(mut w serializer.Writer) {
	p.multiplayer_settings_packet_type.encode(mut w)
}

pub fn (mut p MultiplayerSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.multiplayer_settings_packet_type = enums.MultiplayerSettingsPacketType.decode(mut r)!
}
