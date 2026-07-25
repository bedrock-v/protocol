module types

import serializer

pub struct SubChunkPosOffset {
pub mut:
	offset_x i8
	offset_y i8
	offset_z i8
}

pub fn (t SubChunkPosOffset) encode(mut w serializer.Writer) {
	w.i8(t.offset_x)
	w.i8(t.offset_y)
	w.i8(t.offset_z)
}

pub fn SubChunkPosOffset.decode(mut r serializer.Reader) !SubChunkPosOffset {
	return SubChunkPosOffset{
		offset_x: r.i8()!
		offset_y: r.i8()!
		offset_z: r.i8()!
	}
}
