module types

import serializer
import version.v800.types as types_800
import version.v844.types as types_844
import version.v859.types as types_859

pub struct BiomeDefinitionChunkGenData {
pub mut:
	climate                     ?types_844.BiomeClimateData
	consolidated_features       ?types_800.BiomeConsolidatedFeatureList
	mountain_params             ?types_800.BiomeMountainParamsData
	surface_material_adjustment ?types_800.BiomeSurfaceMaterialAdjustmentData
	overworld_gen_rules         ?types_800.BiomeOverworldGenRulesData
	multinoise_gen_rules        ?types_800.BiomeMultinoiseGenRulesData
	legacy_world_gen_rules      ?types_800.BiomeLegacyWorldGenRulesData
	replacement_biomes          ?[]types_859.BiomeReplacementData
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
		t.overworld_gen_rules = types_800.BiomeOverworldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.multinoise_gen_rules = types_800.BiomeMultinoiseGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		t.legacy_world_gen_rules = types_800.BiomeLegacyWorldGenRulesData.decode(mut r)!
	}
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut replacement_biomes := []types_859.BiomeReplacementData{cap: count}
		for _ in 0 .. count {
			replacement_biomes << types_859.BiomeReplacementData.decode(mut r)!
		}
		t.replacement_biomes = replacement_biomes
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
