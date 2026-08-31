module types

import protocol.serializer

pub struct CameraPresets {
pub mut:
	presets []CameraPreset
}

pub fn (t CameraPresets) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.presets.len))
	for e in t.presets {
		e.encode(mut w)
	}
}

pub fn CameraPresets.decode(mut r serializer.Reader) !CameraPresets {
	count := r.read_count()!
	mut items := []CameraPreset{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << CameraPreset.decode(mut r)!
	}
	return CameraPresets{
		presets: items
	}
}
