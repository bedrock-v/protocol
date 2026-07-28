module enums

import protocol.serializer

pub enum MultiplayerSettingsPacketType as i32 {
	enable_multiplayer  = 0
	disable_multiplayer = 1
	refresh_join_code   = 2
}

pub fn (e MultiplayerSettingsPacketType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn MultiplayerSettingsPacketType.decode(mut r serializer.Reader) !MultiplayerSettingsPacketType {
	return unsafe { MultiplayerSettingsPacketType(r.read_varint32()!) }
}
