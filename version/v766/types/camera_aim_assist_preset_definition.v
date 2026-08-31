module types

import protocol.serializer

pub struct CameraAimAssistPresetDefinition {
pub mut:
	identifier            string
	categories            string
	exclusion_list        []string
	liquid_targeting_list []string
	item_settings         []CameraAimAssistItemSettings
	default_item_settings ?string
	hand_settings         ?string
}

pub fn (t CameraAimAssistPresetDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.identifier)
	w.write_string(t.categories)
	w.write_varuint32(u32(t.exclusion_list.len))
	for s in t.exclusion_list {
		w.write_string(s)
	}
	w.write_varuint32(u32(t.liquid_targeting_list.len))
	for s in t.liquid_targeting_list {
		w.write_string(s)
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
	t.categories = r.read_string()!
	exclusion_count := r.read_count()!
	t.exclusion_list = []string{cap: serializer.prealloc(exclusion_count)}
	for _ in 0 .. exclusion_count {
		t.exclusion_list << r.read_string()!
	}
	liquid_count := r.read_count()!
	t.liquid_targeting_list = []string{cap: serializer.prealloc(liquid_count)}
	for _ in 0 .. liquid_count {
		t.liquid_targeting_list << r.read_string()!
	}
	settings_count := r.read_count()!
	t.item_settings = []CameraAimAssistItemSettings{cap: serializer.prealloc(settings_count)}
	for _ in 0 .. settings_count {
		t.item_settings << CameraAimAssistItemSettings.decode(mut r)!
	}
	if r.bool()! {
		t.default_item_settings = r.read_string()!
	}
	if r.bool()! {
		t.hand_settings = r.read_string()!
	}
	return t
}
