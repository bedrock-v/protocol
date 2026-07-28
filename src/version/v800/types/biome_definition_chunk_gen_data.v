module types

import protocol.serializer

pub struct BiomeDefinitionChunkGenData {
pub mut:
	climate                     ?BiomeClimateData
	consolidated_features       ?BiomeConsolidatedFeatureList
	mountain_params             ?BiomeMountainParamsData
	surface_material_adjustment ?BiomeSurfaceMaterialAdjustmentData
	surface_material            ?BiomeSurfaceMaterialData
	has_swamp_surface           bool
	has_frozen_ocean_surface    bool
	has_the_end_surface         bool
	mesa_surface                ?BiomeMesaSurfaceData
	capped_surface              ?BiomeCappedSurfaceData
	overworld_gen_rules         ?BiomeOverworldGenRulesData
	multinoise_gen_rules        ?BiomeMultinoiseGenRulesData
	legacy_world_gen_rules      ?BiomeLegacyWorldGenRulesData
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
	if v := t.surface_material {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.bool(t.has_swamp_surface)
	w.bool(t.has_frozen_ocean_surface)
	w.bool(t.has_the_end_surface)
	if v := t.mesa_surface {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.capped_surface {
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
		t.surface_material = BiomeSurfaceMaterialData.decode(mut r)!
	}
	t.has_swamp_surface = r.bool()!
	t.has_frozen_ocean_surface = r.bool()!
	t.has_the_end_surface = r.bool()!
	if r.bool()! {
		t.mesa_surface = BiomeMesaSurfaceData.decode(mut r)!
	}
	if r.bool()! {
		t.capped_surface = BiomeCappedSurfaceData.decode(mut r)!
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
	return t
}
