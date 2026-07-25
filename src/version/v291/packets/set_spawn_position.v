module packets

import serializer
import version.v291.types

pub enum SpawnPositionType as i32 {
	player_spawn = 0
	world_spawn  = 1
}

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_type     SpawnPositionType
	block_position types.BlockPosition
	spawn_forced   bool
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
	w.bool(p.spawn_forced)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_type = unsafe { SpawnPositionType(r.read_varint32()!) }
	p.block_position = types.BlockPosition.decode(mut r)!
	p.spawn_forced = r.bool()!
}
