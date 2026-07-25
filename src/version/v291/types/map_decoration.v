module types

import serializer

pub struct MapDecoration {
pub mut:
	image    u8
	rotation u8
	x_offset u8
	y_offset u8
	label    string
	color    u32
}

pub fn (t MapDecoration) encode(mut w serializer.Writer) {
	w.u8(t.image)
	w.u8(t.rotation)
	w.u8(t.x_offset)
	w.u8(t.y_offset)
	w.write_string(t.label)
	w.write_varuint32(t.color)
}

pub fn MapDecoration.decode(mut r serializer.Reader) !MapDecoration {
	return MapDecoration{
		image:    r.u8()!
		rotation: r.u8()!
		x_offset: r.u8()!
		y_offset: r.u8()!
		label:    r.read_string()!
		color:    r.read_varuint32()!
	}
}
