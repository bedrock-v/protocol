module types

import protocol.serializer

pub struct BiomeSurfaceBuilderData {
pub mut:
	surface_material              ?BiomeSurfaceMaterialData
	has_default_overworld_surface bool
	has_swamp_surface             bool
	has_frozen_ocean_surface      bool
	has_the_end_surface           bool
	mesa_surface                  ?BiomeMesaSurfaceData
	capped_surface                ?BiomeCappedSurfaceData
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
		t.surface_material = BiomeSurfaceMaterialData.decode(mut r)!
	}
	t.has_default_overworld_surface = r.bool()!
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
		t.noise_gradient_surface = BiomeNoiseGradientSurfaceData.decode(mut r)!
	}
	return t
}
