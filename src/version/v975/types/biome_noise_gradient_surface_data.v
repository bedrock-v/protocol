module types

import protocol.serializer

pub struct BiomeNoiseGradientSurfaceData {
pub mut:
	non_replaceable_block_runtime_ids []i32
	gradient_block_runtime_ids        []i32
	noise_seed_string                 string
	first_octave                      i32
	amplitudes                        []f32
}

pub fn (t BiomeNoiseGradientSurfaceData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.non_replaceable_block_runtime_ids.len))
	for v in t.non_replaceable_block_runtime_ids {
		w.le_i32(v)
	}
	w.write_varuint32(u32(t.gradient_block_runtime_ids.len))
	for v in t.gradient_block_runtime_ids {
		w.le_i32(v)
	}
	w.write_string(t.noise_seed_string)
	w.le_i32(t.first_octave)
	w.write_varuint32(u32(t.amplitudes.len))
	for v in t.amplitudes {
		w.le_f32(v)
	}
}

pub fn BiomeNoiseGradientSurfaceData.decode(mut r serializer.Reader) !BiomeNoiseGradientSurfaceData {
	mut t := BiomeNoiseGradientSurfaceData{}
	non_replaceable_count := r.read_count()!
	t.non_replaceable_block_runtime_ids = []i32{cap: serializer.prealloc(non_replaceable_count)}
	for _ in 0 .. non_replaceable_count {
		t.non_replaceable_block_runtime_ids << r.le_i32()!
	}
	gradient_count := r.read_count()!
	t.gradient_block_runtime_ids = []i32{cap: serializer.prealloc(gradient_count)}
	for _ in 0 .. gradient_count {
		t.gradient_block_runtime_ids << r.le_i32()!
	}
	t.noise_seed_string = r.read_string()!
	t.first_octave = r.le_i32()!
	amplitude_count := r.read_count()!
	t.amplitudes = []f32{cap: serializer.prealloc(amplitude_count)}
	for _ in 0 .. amplitude_count {
		t.amplitudes << r.le_f32()!
	}
	return t
}
