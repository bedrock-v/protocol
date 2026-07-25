module types

import serializer

pub struct Color {
pub mut:
	r i8
	g i8
	b i8
	a i8
}

pub fn (t Color) encode(mut w serializer.Writer) {
	w.le_u32(u32(i32(t.a)) | (u32(i32(t.r)) << 8) | (u32(i32(t.g)) << 16) | (u32(i32(t.b)) << 24))
}

pub fn Color.decode(mut r serializer.Reader) !Color {
	v := r.le_i32()!
	return Color{
		a: i8(v)
		r: i8(v >> 8)
		g: i8(v >> 16)
		b: i8(v >> 24)
	}
}
