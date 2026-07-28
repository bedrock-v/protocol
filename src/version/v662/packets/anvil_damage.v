module packets

import protocol.serializer
import protocol.version.v662.types

pub struct AnvilDamagePacket {
pub mut:
	damage_amount  i8
	block_position types.NetworkBlockPosition
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
	w.i8(p.damage_amount)
	p.block_position.encode(mut w)
}

pub fn (mut p AnvilDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.damage_amount = r.i8()!
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
}
