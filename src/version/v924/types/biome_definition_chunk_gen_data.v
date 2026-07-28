module types

import protocol.serializer
import protocol.version.v800.types as types_800
import protocol.version.v844.types as types_844
import protocol.version.v859.types as types_859

pub struct BiomeDefinitionChunkGenData {
pub mut:
	climate                       ?types_844.BiomeClimateData
	consolidated_features         ?types_800.BiomeConsolidatedFeatureList
	mountain_params               ?types_800.BiomeMountainParamsData
	surface_material_adjustment   ?types_800.BiomeSurfaceMaterialAdjustmentData
	surface_material              ?types_800.BiomeSurfaceMaterialData
	has_default_overworld_surface bool
	has_swamp_surface             bool
	has_frozen_ocean_surface      bool
	has_the_end_surface           bool
	mesa_surface                  ?types_800.BiomeMesaSurfaceData
	capped_surface                ?types_800.BiomeCappedSurfaceData
	overworld_gen_rules           ?types_800.BiomeOverworldGenRulesData
	multinoise_gen_rules          ?types_800.BiomeMultinoiseGenRulesData
	legacy_world_gen_rules        ?types_800.BiomeLegacyWorldGenRulesData
	replacement_data              ?types_859.BiomeReplacementData
	village_type                  ?u8
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
	w.bool(t.has_default_overworld_surface)
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
	if v := t.replacement_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.village_type {
		w.bool(true)
		w.u8(v)
	} else {
		w.bool(false)
	}
}

pub fn BiomeDefinitionChunkGenData.decode(mut r serializer.Reader) !BiomeDefinitionChunkGenData {
	mut t := BiomeDefinitionChunkGenData{}
	if r.bool()! {
		t.climate = types_844.BiomeClimateData.decode(mut r)!
	}
	if r.bool()! {
		t.consolidated_features = types_800.BiomeConsolidatedFeatureList.decode(mut r)!
	}
	if r.bool()! {
		t.mountain_params = types_800.BiomeMountainParamsData.decode(mut r)!
	}
	if r.bool()! {
		t.surface_material_adjustment = types_800.BiomeSurfaceMaterialAdjustmentData.decode(mut r)!
	}
	if r.bool()! {
		t.surface_material = types_800.BiomeSurfaceMaterialData.decode(mut r)!
	}
	t.has_default_overworld_surface = r.bool()!
	t.has_swamp_surface = r.bool()!
	t.has_frozen_ocean_surface = r.bool()!
	t.has_the_end_surface = r.bool()!
	if r.bool()! {
		t.mesa_surface = types_800.BiomeMesaSurfaceData.decode(mut r)!
	}
	if r.bool()! {
		t.capped_surface = types_800.BiomeCappedSurfaceData.decode(mut r)!
	}
	if r.bool()! {
		t.overworld_gen_rules = types_800.BiomeOverworldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.multinoise_gen_rules = types_800.BiomeMultinoiseGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.legacy_world_gen_rules = types_800.BiomeLegacyWorldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.replacement_data = types_859.BiomeReplacementData.decode(mut r)!
	}
	if r.bool()! {
		t.village_type = r.u8()!
	}
	return t
}
