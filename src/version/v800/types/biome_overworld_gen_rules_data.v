module types

import protocol.serializer

pub struct BiomeOverworldGenRulesData {
pub mut:
	hills_transformations          []BiomeWeightedData
	mutate_transformations         []BiomeWeightedData
	river_transformations          []BiomeWeightedData
	shore_transformations          []BiomeWeightedData
	pre_hills_edge_transformations []BiomeConditionalTransformationData
	post_shore_transformations     []BiomeConditionalTransformationData
	climate_transformations        []BiomeWeightedTemperatureData
}

pub fn (t BiomeOverworldGenRulesData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.hills_transformations.len))
	for e in t.hills_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.mutate_transformations.len))
	for e in t.mutate_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.river_transformations.len))
	for e in t.river_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.shore_transformations.len))
	for e in t.shore_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.pre_hills_edge_transformations.len))
	for e in t.pre_hills_edge_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.post_shore_transformations.len))
	for e in t.post_shore_transformations {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.climate_transformations.len))
	for e in t.climate_transformations {
		e.encode(mut w)
	}
}

pub fn BiomeOverworldGenRulesData.decode(mut r serializer.Reader) !BiomeOverworldGenRulesData {
	mut t := BiomeOverworldGenRulesData{}
	hills_count := r.read_count()!
	t.hills_transformations = []BiomeWeightedData{cap: serializer.prealloc(hills_count)}
	for _ in 0 .. hills_count {
		t.hills_transformations << BiomeWeightedData.decode(mut r)!
	}
	mutate_count := r.read_count()!
	t.mutate_transformations = []BiomeWeightedData{cap: serializer.prealloc(mutate_count)}
	for _ in 0 .. mutate_count {
		t.mutate_transformations << BiomeWeightedData.decode(mut r)!
	}
	river_count := r.read_count()!
	t.river_transformations = []BiomeWeightedData{cap: serializer.prealloc(river_count)}
	for _ in 0 .. river_count {
		t.river_transformations << BiomeWeightedData.decode(mut r)!
	}
	shore_count := r.read_count()!
	t.shore_transformations = []BiomeWeightedData{cap: serializer.prealloc(shore_count)}
	for _ in 0 .. shore_count {
		t.shore_transformations << BiomeWeightedData.decode(mut r)!
	}
	pre_hills_count := r.read_count()!
	t.pre_hills_edge_transformations = []BiomeConditionalTransformationData{cap: serializer.prealloc(pre_hills_count)}
	for _ in 0 .. pre_hills_count {
		t.pre_hills_edge_transformations << BiomeConditionalTransformationData.decode(mut r)!
	}
	post_shore_count := r.read_count()!
	t.post_shore_transformations = []BiomeConditionalTransformationData{cap: serializer.prealloc(post_shore_count)}
	for _ in 0 .. post_shore_count {
		t.post_shore_transformations << BiomeConditionalTransformationData.decode(mut r)!
	}
	climate_count := r.read_count()!
	t.climate_transformations = []BiomeWeightedTemperatureData{cap: serializer.prealloc(climate_count)}
	for _ in 0 .. climate_count {
		t.climate_transformations << BiomeWeightedTemperatureData.decode(mut r)!
	}
	return t
}
