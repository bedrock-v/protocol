module packets

import serializer
import version.v291.types as types_291

pub struct AnvilDamagePacket {
pub mut:
	damage   u8
	position types_291.BlockPosition
}

pub fn (p &AnvilDamagePacket) pid() u16 {
	return 141
}

pub fn (p &AnvilDamagePacket) name() string {
	return 'AnvilDamagePacket'
}

pub fn (p &AnvilDamagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnvilDamagePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.damage)
	p.position.encode(mut w)
}

pub fn (mut p AnvilDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.damage = r.u8()!
	p.position = types_291.BlockPosition.decode(mut r)!
}
