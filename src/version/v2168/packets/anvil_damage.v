module packets

import serializer
import version.v944.types as types_944

pub struct AnvilDamagePacket {
pub mut:
	block_position types_944.NetworkBlockPosition
}

pub fn (p &AnvilDamagePacket) pid() u16 { return 141 }

pub fn (p &AnvilDamagePacket) name() string { return 'AnvilDamagePacket' }

pub fn (p &AnvilDamagePacket) can_be_sent_before_login() bool { return false }

pub fn (p &AnvilDamagePacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
}

pub fn (mut p AnvilDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types_944.NetworkBlockPosition.decode(mut r)!
}
