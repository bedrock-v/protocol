module packets

import serializer
import version.v137.types

pub struct PlayerActionPacket {
pub mut:
	entity_runtime_id u64
	action            i32
	position          types.BlockPosition
	face              i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 36
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	w.write_varint32(p.action)
	p.position.encode(mut w)
	w.write_varint32(p.face)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.action = r.read_varint32()!
	p.position = types.BlockPosition.decode(mut r)!
	p.face = r.read_varint32()!
}
