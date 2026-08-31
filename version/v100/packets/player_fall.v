module packets

import protocol.serializer

pub struct PlayerFallPacket {
pub mut:
	unknown f32
}

pub fn (p &PlayerFallPacket) pid() u16 {
	return 0x25
}

pub fn (p &PlayerFallPacket) name() string {
	return 'PlayerFallPacket'
}

pub fn (p &PlayerFallPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerFallPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.unknown)
}

pub fn (mut p PlayerFallPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown = r.le_f32()!
}
