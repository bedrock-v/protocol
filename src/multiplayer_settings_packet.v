module src

import src.serializer

pub struct MultiplayerSettingsPacket {
pub mut:
	action int
}

pub fn (p &MultiplayerSettingsPacket) pid() u16 {
	return multiplayer_settings_packet
}

pub fn (p &MultiplayerSettingsPacket) name() string {
	return 'MultiplayerSettingsPacket'
}

pub fn (p &MultiplayerSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MultiplayerSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = int(r.read_varint32()!)
}

pub fn (p &MultiplayerSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.action))
}
