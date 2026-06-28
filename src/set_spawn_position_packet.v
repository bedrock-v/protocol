module protocol

import serializer
import types

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_type             int
	spawn_position         types.BlockPosition
	dimension              int
	causing_block_position types.BlockPosition
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return set_spawn_position_packet
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_type = int(r.read_varint32()!)
	p.spawn_position = r.read_block_position()!
	p.dimension = int(r.read_varint32()!)
	p.causing_block_position = r.read_block_position()!
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.spawn_type))
	w.write_block_position(p.spawn_position)
	w.write_varint32(i32(p.dimension))
	w.write_block_position(p.causing_block_position)
}
