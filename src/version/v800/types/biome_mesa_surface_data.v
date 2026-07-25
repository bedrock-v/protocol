module types

import serializer

pub struct BiomeMesaSurfaceData {
pub mut:
	clay_material      i32
	hard_clay_material i32
	bryce_pillars      bool
	has_forest         bool
}

pub fn (t BiomeMesaSurfaceData) encode(mut w serializer.Writer) {
	w.le_i32(t.clay_material)
	w.le_i32(t.hard_clay_material)
	w.bool(t.bryce_pillars)
	w.bool(t.has_forest)
}

pub fn BiomeMesaSurfaceData.decode(mut r serializer.Reader) !BiomeMesaSurfaceData {
	return BiomeMesaSurfaceData{
		clay_material:      r.le_i32()!
		hard_clay_material: r.le_i32()!
		bryce_pillars:      r.bool()!
		has_forest:         r.bool()!
	}
}
