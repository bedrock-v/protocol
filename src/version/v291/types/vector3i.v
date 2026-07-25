module types

import serializer

pub struct Vector3i {
pub mut:
	x i32
	y i32
	z i32
}

pub fn (t Vector3i) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varint32(t.y)
	w.write_varint32(t.z)
}

pub fn Vector3i.decode(mut r serializer.Reader) !Vector3i {
	return Vector3i{
		x: r.read_varint32()!
		y: r.read_varint32()!
		z: r.read_varint32()!
	}
}
