module src

import src.serializer

pub struct OnScreenTextureAnimationPacket {
pub mut:
	effect_id int
}

pub fn (p &OnScreenTextureAnimationPacket) pid() u16 {
	return on_screen_texture_animation_packet
}

pub fn (p &OnScreenTextureAnimationPacket) name() string {
	return 'OnScreenTextureAnimationPacket'
}

pub fn (p &OnScreenTextureAnimationPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p OnScreenTextureAnimationPacket) decode_payload(mut r serializer.Reader) ! {
	p.effect_id = int(r.le_u32()!)
}

pub fn (p &OnScreenTextureAnimationPacket) encode_payload(mut w serializer.Writer) {
	w.le_u32(u32(p.effect_id))
}
