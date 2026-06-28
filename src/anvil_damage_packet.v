module protocol

import serializer
import types

pub struct AnvilDamagePacket {
pub mut:
	damage_amount  int
	block_position types.BlockPosition
}

pub fn (p &AnvilDamagePacket) pid() u16 {
	return anvil_damage_packet
}

pub fn (p &AnvilDamagePacket) name() string {
	return 'AnvilDamagePacket'
}

pub fn (p &AnvilDamagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AnvilDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.damage_amount = int(r.u8()!)
	p.block_position = r.read_block_position()!
}

pub fn (p &AnvilDamagePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.damage_amount))
	w.write_block_position(p.block_position)
}
