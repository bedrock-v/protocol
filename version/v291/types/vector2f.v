module types

import protocol.serializer

pub struct Vector2f {
pub mut:
	x f32
	y f32
}

pub fn (t Vector2f) encode(mut w serializer.Writer) {
	w.le_f32(t.x)
	w.le_f32(t.y)
}

pub fn Vector2f.decode(mut r serializer.Reader) !Vector2f {
	return Vector2f{
		x: r.le_f32()!
		y: r.le_f32()!
	}
}
