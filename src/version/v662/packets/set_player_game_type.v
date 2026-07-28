module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct SetPlayerGameTypePacket {
pub mut:
	player_game_type enums.GameType
}

pub fn (p &SetPlayerGameTypePacket) pid() u16 {
	return 62
}

pub fn (p &SetPlayerGameTypePacket) name() string {
	return 'SetPlayerGameTypePacket'
}

pub fn (p &SetPlayerGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetPlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	p.player_game_type.encode(mut w)
}

pub fn (mut p SetPlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.player_game_type = enums.GameType.decode(mut r)!
}
