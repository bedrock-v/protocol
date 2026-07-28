module types

import protocol.serializer

pub struct SubChunkPos {
pub mut:
	x i32
	y i32
	z i32
}

pub fn (t SubChunkPos) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varint32(t.y)
	w.write_varint32(t.z)
}

pub fn SubChunkPos.decode(mut r serializer.Reader) !SubChunkPos {
	return SubChunkPos{
		x: r.read_varint32()!
		y: r.read_varint32()!
		z: r.read_varint32()!
	}
}
