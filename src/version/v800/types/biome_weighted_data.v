module types

import serializer

pub struct BiomeWeightedData {
pub mut:
	biome  u16
	weight i32
}

pub fn (t BiomeWeightedData) encode(mut w serializer.Writer) {
	w.le_u16(t.biome)
	w.le_i32(t.weight)
}

pub fn BiomeWeightedData.decode(mut r serializer.Reader) !BiomeWeightedData {
	return BiomeWeightedData{
		biome:  r.le_u16()!
		weight: r.le_i32()!
	}
}
