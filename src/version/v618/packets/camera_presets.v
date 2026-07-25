module packets

import serializer
import version.v618.types

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
	count := int(r.read_varuint32()!)
	p.presets = []types.CameraPreset{cap: count}
	for _ in 0 .. count {
		p.presets << types.CameraPreset.decode(mut r)!
	}
}
