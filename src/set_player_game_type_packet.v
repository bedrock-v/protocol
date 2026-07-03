module protocol

import serializer

pub const game_type_survival = int(0)
pub const game_type_creative = int(1)
pub const game_type_adventure = int(2)
pub const game_type_survival_spectator = int(3)
pub const game_type_creative_spectator = int(4)
pub const game_type_default = int(5)
pub const game_type_spectator = int(6)

pub struct SetPlayerGameTypePacket {
pub mut:
	gamemode int
}

pub fn (p &SetPlayerGameTypePacket) pid() u16 {
	return set_player_game_type_packet
}

pub fn (p &SetPlayerGameTypePacket) name() string {
	return 'SetPlayerGameTypePacket'
}

pub fn (p &SetPlayerGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetPlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.gamemode = int(r.read_varint32()!)
}

pub fn (p &SetPlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.gamemode))
}
