module types

import protocol.serializer

pub struct BiomeSurfaceMaterialAdjustmentData {
pub mut:
	biome_elements []BiomeElementData
}

pub fn (t BiomeSurfaceMaterialAdjustmentData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.biome_elements.len))
	for e in t.biome_elements {
		e.encode(mut w)
	}
}

pub fn BiomeSurfaceMaterialAdjustmentData.decode(mut r serializer.Reader) !BiomeSurfaceMaterialAdjustmentData {
	count := r.read_count()!
	mut items := []BiomeElementData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << BiomeElementData.decode(mut r)!
	}
	return BiomeSurfaceMaterialAdjustmentData{
		biome_elements: items
	}
}
