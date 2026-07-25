module packets

import serializer

pub struct PlayerInputPacket {
pub mut:
	motion_x      f32
	motion_y      f32
	unknown_bool1 bool
	unknown_bool2 bool
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
	w.le_f32(p.motion_x)
	w.le_f32(p.motion_y)
	w.bool(p.unknown_bool1)
	w.bool(p.unknown_bool2)
}

pub fn (mut p PlayerInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.motion_x = r.le_f32()!
	p.motion_y = r.le_f32()!
	p.unknown_bool1 = r.bool()!
	p.unknown_bool2 = r.bool()!
}
