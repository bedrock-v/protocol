module packets

import serializer
import version.v924.types
import version.v776.enums as enums_776

pub struct CameraAimAssistPresetsPacket {
pub mut:
	category_definitions []types.CameraAimAssistCategory
	presets              []types.CameraAimAssistPresetDefinition
	operation            enums_776.CameraAimAssistOperation
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
	w.write_varuint32(u32(p.category_definitions.len))
	for c in p.category_definitions {
		c.encode(mut w)
	}
	w.write_varuint32(u32(p.presets.len))
	for preset in p.presets {
		preset.encode(mut w)
	}
	p.operation.encode(mut w)
}

pub fn (mut p CameraAimAssistPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	category_count := int(r.read_varuint32()!)
	p.category_definitions = []types.CameraAimAssistCategory{cap: category_count}
	for _ in 0 .. category_count {
		p.category_definitions << types.CameraAimAssistCategory.decode(mut r)!
	}
	preset_count := int(r.read_varuint32()!)
	p.presets = []types.CameraAimAssistPresetDefinition{cap: preset_count}
	for _ in 0 .. preset_count {
		p.presets << types.CameraAimAssistPresetDefinition.decode(mut r)!
	}
	p.operation = enums_776.CameraAimAssistOperation.decode(mut r)!
}
