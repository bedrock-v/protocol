module types

import protocol.serializer

pub struct BiomeMultinoiseGenRulesData {
pub mut:
	temperature f32
	humidity    f32
	altitude    f32
	weirdness   f32
	weight      f32
}

pub fn (t BiomeMultinoiseGenRulesData) encode(mut w serializer.Writer) {
	w.le_f32(t.temperature)
	w.le_f32(t.humidity)
	w.le_f32(t.altitude)
	w.le_f32(t.weirdness)
	w.le_f32(t.weight)
}

pub fn BiomeMultinoiseGenRulesData.decode(mut r serializer.Reader) !BiomeMultinoiseGenRulesData {
	return BiomeMultinoiseGenRulesData{
		temperature: r.le_f32()!
		humidity:    r.le_f32()!
		altitude:    r.le_f32()!
		weirdness:   r.le_f32()!
		weight:      r.le_f32()!
	}
}
