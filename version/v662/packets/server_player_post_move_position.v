module packets

import protocol.serializer

pub struct ServerPlayerPostMovePositionPacket {
pub mut:
	pos [3]f32
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
	w.le_f32(p.pos[0])
	w.le_f32(p.pos[1])
	w.le_f32(p.pos[2])
}

pub fn (mut p ServerPlayerPostMovePositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.pos = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
}
