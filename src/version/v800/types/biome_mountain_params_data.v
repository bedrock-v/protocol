module types

import serializer

pub struct BiomeMountainParamsData {
pub mut:
	steep_block       i32
	north_slopes      bool
	south_slopes      bool
	west_slopes       bool
	east_slopes       bool
	top_slide_enabled bool
}

pub fn (t BiomeMountainParamsData) encode(mut w serializer.Writer) {
	w.le_i32(t.steep_block)
	w.bool(t.north_slopes)
	w.bool(t.south_slopes)
	w.bool(t.west_slopes)
	w.bool(t.east_slopes)
	w.bool(t.top_slide_enabled)
}

pub fn BiomeMountainParamsData.decode(mut r serializer.Reader) !BiomeMountainParamsData {
	return BiomeMountainParamsData{
		steep_block:       r.le_i32()!
		north_slopes:      r.bool()!
		south_slopes:      r.bool()!
		west_slopes:       r.bool()!
		east_slopes:       r.bool()!
		top_slide_enabled: r.bool()!
	}
}
