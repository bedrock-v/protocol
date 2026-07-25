module packets

import serializer
import version.v766.types

pub struct CameraAimAssistPresetsPacket {
pub mut:
	categories []types.CameraAimAssistCategories
	presets    []types.CameraAimAssistPresetDefinition
}

pub fn (p &CameraAimAssistPresetsPacket) pid() u16 {
	return 320
}

pub fn (p &CameraAimAssistPresetsPacket) name() string {
	return 'CameraAimAssistPresetsPacket'
}

pub fn (p &CameraAimAssistPresetsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraAimAssistPresetsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.categories.len))
	for e in p.categories {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.presets.len))
	for e in p.presets {
		e.encode(mut w)
	}
}

pub fn (mut p CameraAimAssistPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.categories = []types.CameraAimAssistCategories{cap: count}
		for _ in 0 .. count {
			p.categories << types.CameraAimAssistCategories.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.presets = []types.CameraAimAssistPresetDefinition{cap: count}
		for _ in 0 .. count {
			p.presets << types.CameraAimAssistPresetDefinition.decode(mut r)!
		}
	}
}
