module packets

import protocol.serializer
import protocol.version.v618.types

pub struct CameraPresetsPacket {
pub mut:
	presets []types.CameraPreset
}

pub fn (p &CameraPresetsPacket) pid() u16 {
	return 198
}

pub fn (p &CameraPresetsPacket) name() string {
	return 'CameraPresetsPacket'
}

pub fn (p &CameraPresetsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraPresetsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.presets.len))
	for preset in p.presets {
		preset.encode(mut w)
	}
}

pub fn (mut p CameraPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.presets = []types.CameraPreset{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.presets << types.CameraPreset.decode(mut r)!
	}
}
