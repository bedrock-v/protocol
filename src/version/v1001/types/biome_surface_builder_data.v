module types

import serializer
import version.v800.types as types_800

pub struct BiomeSurfaceBuilderData {
pub mut:
	surface_material              ?types_800.BiomeSurfaceMaterialData
	has_default_overworld_surface bool
	has_swamp_surface             bool
	has_frozen_ocean_surface      bool
	has_the_end_surface           bool
	mesa_surface                  ?types_800.BiomeMesaSurfaceData
	capped_surface                ?types_800.BiomeCappedSurfaceData
	noise_gradient_surface        ?BiomeNoiseGradientSurfaceData
}

pub fn (t BiomeSurfaceBuilderData) encode(mut w serializer.Writer) {
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
	if v := t.noise_gradient_surface {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn BiomeSurfaceBuilderData.decode(mut r serializer.Reader) !BiomeSurfaceBuilderData {
	mut t := BiomeSurfaceBuilderData{}
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
		t.noise_gradient_surface = BiomeNoiseGradientSurfaceData.decode(mut r)!
	}
	return t
}
