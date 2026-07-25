module packets

import serializer

pub enum MultiplayerMode as i32 {
	enable_multiplayer  = 0
	disable_multiplayer = 1
	refresh_join_code   = 2
}

pub struct MultiplayerSettingsPacket {
pub mut:
	mode MultiplayerMode
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
	w.write_varint32(i32(p.mode))
}

pub fn (mut p MultiplayerSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.mode = unsafe { MultiplayerMode(r.read_varint32()!) }
}
