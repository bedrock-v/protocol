module packets

import serializer
import version.v662.types
import version.v662.enums

pub struct UpdatePlayerGameTypePacket {
pub mut:
	player_game_type enums.GameType
	target_player    types.ActorUniqueID
}

pub fn (p &UpdatePlayerGameTypePacket) pid() u16 { return 151 }

pub fn (p &UpdatePlayerGameTypePacket) name() string { return 'UpdatePlayerGameTypePacket' }

pub fn (p &UpdatePlayerGameTypePacket) can_be_sent_before_login() bool { return false }

pub fn (p &UpdatePlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	p.player_game_type.encode(mut w)
	p.target_player.encode(mut w)
}

pub fn (mut p UpdatePlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.player_game_type = enums.GameType.decode(mut r)!
	p.target_player = types.ActorUniqueID.decode(mut r)!
}
