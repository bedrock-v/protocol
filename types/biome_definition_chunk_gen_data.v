module types

import protocol.serializer

pub struct BiomeDefinitionChunkGenData {
pub mut:
	climate                     ?BiomeClimateData
	consolidated_features       ?BiomeConsolidatedFeatureList
	mountain_params             ?BiomeMountainParamsData
	surface_material_adjustment ?BiomeSurfaceMaterialAdjustmentData
	overworld_gen_rules         ?BiomeOverworldGenRulesData
	multinoise_gen_rules        ?BiomeMultinoiseGenRulesData
	legacy_world_gen_rules      ?BiomeLegacyWorldGenRulesData
	replacement_biomes          ?[]BiomeReplacementData
	village_type                ?u8
	surface_builder_data        ?BiomeSurfaceBuilderData
	sub_surface_builder_data    ?BiomeSurfaceBuilderData
}

pub fn (t BiomeDefinitionChunkGenData) encode(mut w serializer.Writer) {
	if v := t.climate {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.consolidated_features {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.mountain_params {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.surface_material_adjustment {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.overworld_gen_rules {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.multinoise_gen_rules {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.legacy_world_gen_rules {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.replacement_biomes {
		w.bool(true)
		w.write_varuint32(u32(v.len))
		for e in v {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	if v := t.village_type {
		w.bool(true)
		w.u8(v)
	} else {
		w.bool(false)
	}
	if v := t.surface_builder_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.sub_surface_builder_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn BiomeDefinitionChunkGenData.decode(mut r serializer.Reader) !BiomeDefinitionChunkGenData {
	mut t := BiomeDefinitionChunkGenData{}
	if r.bool()! {
		t.climate = BiomeClimateData.decode(mut r)!
	}
	if r.bool()! {
		t.consolidated_features = BiomeConsolidatedFeatureList.decode(mut r)!
	}
	if r.bool()! {
		t.mountain_params = BiomeMountainParamsData.decode(mut r)!
	}
	if r.bool()! {
		t.surface_material_adjustment = BiomeSurfaceMaterialAdjustmentData.decode(mut r)!
	}
	if r.bool()! {
		t.overworld_gen_rules = BiomeOverworldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.multinoise_gen_rules = BiomeMultinoiseGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.legacy_world_gen_rules = BiomeLegacyWorldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		count := r.read_count()!
		mut items := []BiomeReplacementData{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			items << BiomeReplacementData.decode(mut r)!
		}
		t.replacement_biomes = items
	}
	if r.bool()! {
		t.village_type = r.u8()!
	}
	if r.bool()! {
		t.surface_builder_data = BiomeSurfaceBuilderData.decode(mut r)!
	}
	if r.bool()! {
		t.sub_surface_builder_data = BiomeSurfaceBuilderData.decode(mut r)!
	}
	return t
}
