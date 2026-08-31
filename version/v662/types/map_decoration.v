module types

import protocol.serializer
import protocol.version.v662.enums

pub struct MapDecoration {
pub mut:
	map_decoration_type enums.MapDecorationType
	rotation            i8
	x                   i8
	y                   i8
	label               string
	color_argb          u32
}

pub fn (t MapDecoration) encode(mut w serializer.Writer) {
	t.map_decoration_type.encode(mut w)
	w.i8(t.rotation)
	w.i8(t.x)
	w.i8(t.y)
	w.write_string(t.label)
	w.write_varuint32(t.color_argb)
}

pub fn MapDecoration.decode(mut r serializer.Reader) !MapDecoration {
	return MapDecoration{
		map_decoration_type: enums.MapDecorationType.decode(mut r)!
		rotation:            r.i8()!
		x:                   r.i8()!
		y:                   r.i8()!
		label:               r.read_string()!
		color_argb:          r.read_varuint32()!
	}
}
