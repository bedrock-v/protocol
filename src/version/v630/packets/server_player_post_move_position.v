module packets

import serializer
import version.v291.types as types_291

pub struct ServerPlayerPostMovePositionPacket {
pub mut:
	position types_291.Vector3f
}

pub fn (p &ServerPlayerPostMovePositionPacket) pid() u16 {
	return 16
}

pub fn (p &ServerPlayerPostMovePositionPacket) name() string {
	return 'ServerPlayerPostMovePositionPacket'
}

pub fn (p &ServerPlayerPostMovePositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerPlayerPostMovePositionPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
}

pub fn (mut p ServerPlayerPostMovePositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.Vector3f.decode(mut r)!
}
