module packets

import serializer
import version.v291.types

pub struct PlayerInputPacket {
pub mut:
	input_motion types.Vector2f
	jumping      bool
	sneaking     bool
}

pub fn (p &PlayerInputPacket) pid() u16 {
	return 57
}

pub fn (p &PlayerInputPacket) name() string {
	return 'PlayerInputPacket'
}

pub fn (p &PlayerInputPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerInputPacket) encode_payload(mut w serializer.Writer) {
	p.input_motion.encode(mut w)
	w.bool(p.jumping)
	w.bool(p.sneaking)
}

pub fn (mut p PlayerInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.input_motion = types.Vector2f.decode(mut r)!
	p.jumping = r.bool()!
	p.sneaking = r.bool()!
}
