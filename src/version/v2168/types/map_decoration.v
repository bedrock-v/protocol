module types

import serializer

pub enum MapDecorationType as i8 {
	marker_white       = 0
	marker_green       = 1
	marker_red         = 2
	marker_blue        = 3
	x_white            = 4
	triangle_red       = 5
	square_white       = 6
	marker_sign        = 7
	marker_pink        = 8
	marker_orange      = 9
	marker_yellow      = 10
	marker_teal        = 11
	triangle_green     = 12
	small_square_white = 13
	mansion            = 14
	monument           = 15
	no_draw            = 16
	village_desert     = 17
	village_plains     = 18
	village_savanna    = 19
	village_snowy      = 20
	village_taiga      = 21
	jungle_temple      = 22
	witch_hut          = 23
	trial_chambers     = 24
	count              = 25
}

pub fn (e MapDecorationType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn MapDecorationType.decode(mut r serializer.Reader) !MapDecorationType {
	return unsafe { MapDecorationType(r.i8()!) }
}

pub struct MapDecoration {
pub mut:
	map_decoration_type MapDecorationType
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
	w.le_u32(t.color_argb)
}

pub fn MapDecoration.decode(mut r serializer.Reader) !MapDecoration {
	return MapDecoration{
		map_decoration_type: MapDecorationType.decode(mut r)!
		rotation:            r.i8()!
		x:                   r.i8()!
		y:                   r.i8()!
		label:               r.read_string()!
		color_argb:          r.le_u32()!
	}
}
