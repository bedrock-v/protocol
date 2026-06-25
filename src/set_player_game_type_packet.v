module src

import src.serializer

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
