module types

import protocol.serializer

pub struct BiomeClimateData {
pub mut:
	temperature           f32
	downfall              f32
	snow_accumulation_min f32
	snow_accumulation_max f32
}

pub fn (t BiomeClimateData) encode(mut w serializer.Writer) {
	w.le_f32(t.temperature)
	w.le_f32(t.downfall)
	w.le_f32(t.snow_accumulation_min)
	w.le_f32(t.snow_accumulation_max)
}

pub fn BiomeClimateData.decode(mut r serializer.Reader) !BiomeClimateData {
	return BiomeClimateData{
		temperature:           r.le_f32()!
		downfall:              r.le_f32()!
		snow_accumulation_min: r.le_f32()!
		snow_accumulation_max: r.le_f32()!
	}
}
