module types

import protocol.serializer

pub struct BiomeReplacementData {
pub mut:
	biome                 i16
	dimension             i16
	target_biomes         []i16
	amount                f32
	noise_frequency_scale f32
	replacement_index     i32
}

pub fn (t BiomeReplacementData) encode(mut w serializer.Writer) {
	w.le_i16(t.biome)
	w.le_i16(t.dimension)
	w.write_varuint32(u32(t.target_biomes.len))
	for e in t.target_biomes {
		w.le_i16(e)
	}
	w.le_f32(t.amount)
	w.le_f32(t.noise_frequency_scale)
	w.le_i32(t.replacement_index)
}

pub fn BiomeReplacementData.decode(mut r serializer.Reader) !BiomeReplacementData {
	mut t := BiomeReplacementData{}
	t.biome = r.le_i16()!
	t.dimension = r.le_i16()!
	count := r.read_count()!
	mut target_biomes := []i16{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		target_biomes << r.le_i16()!
	}
	t.target_biomes = target_biomes
	t.amount = r.le_f32()!
	t.noise_frequency_scale = r.le_f32()!
	t.replacement_index = r.le_i32()!
	return t
}
