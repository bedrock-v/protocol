module src

import src.serializer
import src.types

pub struct PlayerActionPacket {
pub mut:
	actor_runtime_id u64
	action           int
	block_position   types.BlockPosition
	result_position  types.BlockPosition
	face             int
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return player_action_packet
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.action = int(r.read_varint32()!)
	p.block_position = r.read_block_position()!
	p.result_position = r.read_block_position()!
	p.face = int(r.read_varint32()!)
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_varint32(i32(p.action))
	w.write_block_position(p.block_position)
	w.write_block_position(p.result_position)
	w.write_varint32(i32(p.face))
}
