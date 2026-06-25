module src

import src.serializer

pub struct UpdatePlayerGameTypePacket {
pub mut:
	game_mode              int
	player_actor_unique_id i64
	tick                   u64
}

pub fn (p &UpdatePlayerGameTypePacket) pid() u16 {
	return update_player_game_type_packet
}

pub fn (p &UpdatePlayerGameTypePacket) name() string {
	return 'UpdatePlayerGameTypePacket'
}

pub fn (p &UpdatePlayerGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdatePlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.game_mode = int(r.read_varint32()!)
	p.player_actor_unique_id = r.read_actor_unique_id()!
	p.tick = r.read_varuint64()!
}

pub fn (p &UpdatePlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.game_mode))
	w.write_actor_unique_id(p.player_actor_unique_id)
	w.write_varuint64(p.tick)
}
