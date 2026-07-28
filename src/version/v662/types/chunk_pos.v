module types

import protocol.serializer

pub struct ChunkPos {
pub mut:
	x i32
	z i32
}

pub fn (t ChunkPos) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varint32(t.z)
}

pub fn ChunkPos.decode(mut r serializer.Reader) !ChunkPos {
	return ChunkPos{
		x: r.read_varint32()!
		z: r.read_varint32()!
	}
}
