module types

import protocol.serializer

pub struct BiomeElementData {
pub mut:
	noise_frequency_scale f32
	noise_lower_bound     f32
	noise_upper_bound     f32
	height_min_type       i32
	height_min            u16
	height_max_type       i32
	height_max            u16
	adjusted_materials    BiomeSurfaceMaterialData
}

pub fn (t BiomeElementData) encode(mut w serializer.Writer) {
	w.le_f32(t.noise_frequency_scale)
	w.le_f32(t.noise_lower_bound)
	w.le_f32(t.noise_upper_bound)
	w.write_varint32(t.height_min_type)
	w.le_u16(t.height_min)
	w.write_varint32(t.height_max_type)
	w.le_u16(t.height_max)
	t.adjusted_materials.encode(mut w)
}

pub fn BiomeElementData.decode(mut r serializer.Reader) !BiomeElementData {
	return BiomeElementData{
		noise_frequency_scale: r.le_f32()!
		noise_lower_bound:     r.le_f32()!
		noise_upper_bound:     r.le_f32()!
		height_min_type:       r.read_varint32()!
		height_min:            r.le_u16()!
		height_max_type:       r.read_varint32()!
		height_max:            r.le_u16()!
		adjusted_materials:    BiomeSurfaceMaterialData.decode(mut r)!
	}
}
