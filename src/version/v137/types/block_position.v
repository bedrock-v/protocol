module types

import serializer

pub struct BlockPosition {
pub mut:
	x i32
	y u32
	z i32
}

pub fn (t BlockPosition) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varuint32(t.y)
	w.write_varint32(t.z)
}

pub fn BlockPosition.decode(mut r serializer.Reader) !BlockPosition {
	return BlockPosition{
		x: r.read_varint32()!
		y: r.read_varuint32()!
		z: r.read_varint32()!
	}
}
