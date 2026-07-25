module packets

import serializer

pub struct PlayerInputPacket {
pub mut:
	move_vector [2]f32
	jumping     bool
	sneaking    bool
}

pub fn (p &PlayerInputPacket) pid() u16 { return 57 }

pub fn (p &PlayerInputPacket) name() string { return 'PlayerInputPacket' }

pub fn (p &PlayerInputPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerInputPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.move_vector[0])
	w.le_f32(p.move_vector[1])
	w.bool(p.jumping)
	w.bool(p.sneaking)
}

pub fn (mut p PlayerInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.move_vector = [r.le_f32()!, r.le_f32()!]!
	p.jumping = r.bool()!
	p.sneaking = r.bool()!
}
