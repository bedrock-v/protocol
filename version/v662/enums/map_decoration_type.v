module enums

import protocol.serializer

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
	count              = 24
}

pub fn (e MapDecorationType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn MapDecorationType.decode(mut r serializer.Reader) !MapDecorationType {
	return unsafe { MapDecorationType(r.i8()!) }
}
