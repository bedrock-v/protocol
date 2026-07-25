module packets

import serializer
import version.v291.types as types_291

pub enum SpawnPositionType as i32 {
	player_spawn = 0
	world_spawn  = 1
}

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_type     SpawnPositionType
	block_position types_291.BlockPosition
	dimension_id   i32
	spawn_position types_291.BlockPosition
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 43
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.spawn_type))
	p.block_position.encode(mut w)
	w.write_varint32(p.dimension_id)
	p.spawn_position.encode(mut w)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_type = unsafe { SpawnPositionType(r.read_varint32()!) }
	p.block_position = types_291.BlockPosition.decode(mut r)!
	p.dimension_id = r.read_varint32()!
	p.spawn_position = types_291.BlockPosition.decode(mut r)!
}
