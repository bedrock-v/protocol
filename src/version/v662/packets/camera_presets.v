module packets

import serializer
import version.v662.types

pub struct CameraPresetsPacket {
pub mut:
	camera_presets types.CameraPresets
}

pub fn (p &CameraPresetsPacket) pid() u16 { return 198 }

pub fn (p &CameraPresetsPacket) name() string { return 'CameraPresetsPacket' }

pub fn (p &CameraPresetsPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CameraPresetsPacket) encode_payload(mut w serializer.Writer) {
	p.camera_presets.encode(mut w)
}

pub fn (mut p CameraPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	p.camera_presets = types.CameraPresets.decode(mut r)!
}
