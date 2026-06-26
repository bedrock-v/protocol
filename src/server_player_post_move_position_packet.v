module src

import src.serializer
import src.types

pub struct ServerPlayerPostMovePositionPacket {
pub mut:
	position types.Vector3
}

pub fn (p &ServerPlayerPostMovePositionPacket) pid() u16 {
	return server_player_post_move_position_packet
}

pub fn (p &ServerPlayerPostMovePositionPacket) name() string {
	return 'ServerPlayerPostMovePositionPacket'
}

pub fn (p &ServerPlayerPostMovePositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerPlayerPostMovePositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = r.read_vector3()!
}

pub fn (p &ServerPlayerPostMovePositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_vector3(p.position)
}
