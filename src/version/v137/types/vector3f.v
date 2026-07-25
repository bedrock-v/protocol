module types

import serializer

pub struct Vector3f {
pub mut:
	x f32
	y f32
	z f32
}

pub fn (t Vector3f) encode(mut w serializer.Writer) {
	w.le_f32(t.x)
	w.le_f32(t.y)
	w.le_f32(t.z)
}

pub fn Vector3f.decode(mut r serializer.Reader) !Vector3f {
	return Vector3f{
		x: r.le_f32()!
		y: r.le_f32()!
		z: r.le_f32()!
	}
}
