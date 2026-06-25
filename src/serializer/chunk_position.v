module serializer

import src.types

pub fn (mut r Reader) read_chunk_position() !types.ChunkPosition {
	return types.ChunkPosition{
		x: int(r.read_varint32()!)
		z: int(r.read_varint32()!)
	}
}

pub fn (mut w Writer) write_chunk_position(pos types.ChunkPosition) {
	w.write_varint32(i32(pos.x))
	w.write_varint32(i32(pos.z))
}
