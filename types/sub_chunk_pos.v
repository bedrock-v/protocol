module types

import protocol.serializer

pub struct SubChunkPos {
pub mut:
	x i32
	y i32
	z i32
}

pub fn (t SubChunkPos) encode(mut w serializer.Writer) {
	w.le_i32(t.x)
	w.le_i32(t.y)
	w.le_i32(t.z)
}

pub fn SubChunkPos.decode(mut r serializer.Reader) !SubChunkPos {
	return SubChunkPos{
		x: r.le_i32()!
		y: r.le_i32()!
		z: r.le_i32()!
	}
}
