module types

import protocol.serializer

pub struct BiomeConditionalTransformationData {
pub mut:
	weighted_biomes       []BiomeWeightedData
	condition_json        u16
	min_passing_neighbors u32
}

pub fn (t BiomeConditionalTransformationData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.weighted_biomes.len))
	for e in t.weighted_biomes {
		e.encode(mut w)
	}
	w.le_u16(t.condition_json)
	w.le_u32(t.min_passing_neighbors)
}

pub fn BiomeConditionalTransformationData.decode(mut r serializer.Reader) !BiomeConditionalTransformationData {
	mut t := BiomeConditionalTransformationData{}
	count := int(r.read_varuint32()!)
	t.weighted_biomes = []BiomeWeightedData{cap: count}
	for _ in 0 .. count {
		t.weighted_biomes << BiomeWeightedData.decode(mut r)!
	}
	t.condition_json = r.le_u16()!
	t.min_passing_neighbors = r.le_u32()!
	return t
}
