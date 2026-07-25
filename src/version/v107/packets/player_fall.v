module packets

import serializer

pub struct PlayerFallPacket {
pub mut:
	fall_distance f32
}

pub fn (p &PlayerFallPacket) pid() u16 {
	return 0x26
}

pub fn (p &PlayerFallPacket) name() string {
	return 'PlayerFallPacket'
}

pub fn (p &PlayerFallPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerFallPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.fall_distance)
}

pub fn (mut p PlayerFallPacket) decode_payload(mut r serializer.Reader) ! {
	p.fall_distance = r.le_f32()!
}
