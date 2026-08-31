module types

import protocol.serializer
import protocol.version.v766.types as types_766

pub struct CameraAimAssistPresetDefinition {
pub mut:
	identifier            string
	exclusion_list        []string
	liquid_targeting_list []string
	item_settings         []types_766.CameraAimAssistItemSettings
	default_item_settings ?string
	hand_settings         ?string
}

pub fn (t CameraAimAssistPresetDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.identifier)
	w.write_varuint32(u32(t.exclusion_list.len))
	for e in t.exclusion_list {
		w.write_string(e)
	}
	w.write_varuint32(u32(t.liquid_targeting_list.len))
	for e in t.liquid_targeting_list {
		w.write_string(e)
	}
	w.write_varuint32(u32(t.item_settings.len))
	for e in t.item_settings {
		e.encode(mut w)
	}
	if v := t.default_item_settings {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	if v := t.hand_settings {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraAimAssistPresetDefinition.decode(mut r serializer.Reader) !CameraAimAssistPresetDefinition {
	mut t := CameraAimAssistPresetDefinition{}
	t.identifier = r.read_string()!
	{
		count := r.read_count()!
		t.exclusion_list = []string{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.exclusion_list << r.read_string()!
		}
	}
	{
		count := r.read_count()!
		t.liquid_targeting_list = []string{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.liquid_targeting_list << r.read_string()!
		}
	}
	{
		count := r.read_count()!
		t.item_settings = []types_766.CameraAimAssistItemSettings{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.item_settings << types_766.CameraAimAssistItemSettings.decode(mut r)!
		}
	}
	if r.bool()! {
		t.default_item_settings = r.read_string()!
	}
	if r.bool()! {
		t.hand_settings = r.read_string()!
	}
	return t
}
