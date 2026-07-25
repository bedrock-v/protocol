module types

import serializer

pub struct ImageData {
pub mut:
	width  i32
	height i32
	image  []u8
}

pub fn (t ImageData) encode(mut w serializer.Writer) {
	w.le_i32(t.width)
	w.le_i32(t.height)
	w.write_string_bytes(t.image)
}

pub fn ImageData.decode(mut r serializer.Reader) !ImageData {
	return ImageData{
		width:  r.le_i32()!
		height: r.le_i32()!
		image:  r.read_string_bytes()!
	}
}
