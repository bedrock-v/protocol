module enums

import serializer

pub enum SpawnPositionType as i32 {
	player_respawn = 0
	world_spawn    = 1
}

pub fn (e SpawnPositionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn SpawnPositionType.decode(mut r serializer.Reader) !SpawnPositionType {
	return unsafe { SpawnPositionType(r.read_varint32()!) }
}
