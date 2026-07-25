module types

import serializer

pub struct BiomeWeightedTemperatureData {
pub mut:
	temperature i32
	weight      i32
}

pub fn (t BiomeWeightedTemperatureData) encode(mut w serializer.Writer) {
	w.write_varint32(t.temperature)
	w.le_i32(t.weight)
}

pub fn BiomeWeightedTemperatureData.decode(mut r serializer.Reader) !BiomeWeightedTemperatureData {
	return BiomeWeightedTemperatureData{
		temperature: r.read_varint32()!
		weight:      r.le_i32()!
	}
}
