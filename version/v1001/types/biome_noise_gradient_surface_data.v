module types

import protocol.serializer

pub struct BiomeNoiseGradientSurfaceData {
pub mut:
	non_replaceable_block_runtime_ids []i32
	gradient_blocks                   []NoiseBlockSpecifier
	noise                             string
	first_octave                      i32
	amplitudes                        []f32
}

pub fn (t BiomeNoiseGradientSurfaceData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.non_replaceable_block_runtime_ids.len))
	for v in t.non_replaceable_block_runtime_ids {
		w.le_i32(v)
	}
	w.write_varuint32(u32(t.gradient_blocks.len))
	for e in t.gradient_blocks {
		e.encode(mut w)
	}
	w.write_string(t.noise)
	w.le_i32(t.first_octave)
	w.write_varuint32(u32(t.amplitudes.len))
	for v in t.amplitudes {
		w.le_f32(v)
	}
}

pub fn BiomeNoiseGradientSurfaceData.decode(mut r serializer.Reader) !BiomeNoiseGradientSurfaceData {
	mut t := BiomeNoiseGradientSurfaceData{}
	{
		count := r.read_count()!
		t.non_replaceable_block_runtime_ids = []i32{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.non_replaceable_block_runtime_ids << r.le_i32()!
		}
	}
	{
		count := r.read_count()!
		t.gradient_blocks = []NoiseBlockSpecifier{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.gradient_blocks << NoiseBlockSpecifier.decode(mut r)!
		}
	}
	t.noise = r.read_string()!
	t.first_octave = r.le_i32()!
	{
		count := r.read_count()!
		t.amplitudes = []f32{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.amplitudes << r.le_f32()!
		}
	}
	return t
}

pub struct NoiseBlockSpecifier {
pub mut:
	noise            string
	threshold        f32
	range_min        f32
	range_max        f32
	block_runtime_id i32
}

pub fn (t NoiseBlockSpecifier) encode(mut w serializer.Writer) {
	w.write_string(t.noise)
	w.le_f32(t.threshold)
	w.le_f32(t.range_min)
	w.le_f32(t.range_max)
	w.le_i32(t.block_runtime_id)
}

pub fn NoiseBlockSpecifier.decode(mut r serializer.Reader) !NoiseBlockSpecifier {
	return NoiseBlockSpecifier{
		noise:            r.read_string()!
		threshold:        r.le_f32()!
		range_min:        r.le_f32()!
		range_max:        r.le_f32()!
		block_runtime_id: r.le_i32()!
	}
}
