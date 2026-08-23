module types

import protocol.serializer

pub struct BiomeTagList {
pub mut:
	tags []u16
}

pub fn (t BiomeTagList) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.tags.len))
	for e in t.tags {
		w.le_u16(e)
	}
}

pub fn BiomeTagList.decode(mut r serializer.Reader) !BiomeTagList {
	count := r.read_count()!
	mut tags := []u16{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		tags << r.le_u16()!
	}
	return BiomeTagList{
		tags: tags
	}
}

pub struct BiomeDefinition {
pub mut:
	id              u16
	temperature     f32
	downfall        f32
	foliage_snow    f32
	depth           f32
	scale           f32
	map_water_color i32
	rain            bool
	tags            ?BiomeTagList
	chunk_gen_data  ?BiomeDefinitionChunkGenData
}

pub fn (t BiomeDefinition) encode(mut w serializer.Writer) {
	w.le_u16(t.id)
	w.le_f32(t.temperature)
	w.le_f32(t.downfall)
	w.le_f32(t.foliage_snow)
	w.le_f32(t.depth)
	w.le_f32(t.scale)
	w.le_i32(t.map_water_color)
	w.bool(t.rain)
	if v := t.tags {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.chunk_gen_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn BiomeDefinition.decode(mut r serializer.Reader) !BiomeDefinition {
	mut t := BiomeDefinition{}
	t.id = r.le_u16()!
	t.temperature = r.le_f32()!
	t.downfall = r.le_f32()!
	t.foliage_snow = r.le_f32()!
	t.depth = r.le_f32()!
	t.scale = r.le_f32()!
	t.map_water_color = r.le_i32()!
	t.rain = r.bool()!
	if r.bool()! {
		t.tags = BiomeTagList.decode(mut r)!
	}
	if r.bool()! {
		t.chunk_gen_data = BiomeDefinitionChunkGenData.decode(mut r)!
	}
	return t
}
