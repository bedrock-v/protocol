module types

import protocol.serializer
import protocol.version.v766.types as types_766

pub struct CameraAimAssistPresetDefinition {
pub mut:
	identifier               string
	block_exclusion_list     []string
	entity_exclusion_list    []string
	block_tag_exclusion_list []string
	liquid_targeting_list    []string
	item_settings            []types_766.CameraAimAssistItemSettings
	default_item_settings    ?string
	hand_settings            ?string
}

fn write_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

fn read_string_list(mut r serializer.Reader) ![]string {
	count := r.read_count()!
	mut out := []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		out << r.read_string()!
	}
	return out
}

pub fn (t CameraAimAssistPresetDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.identifier)
	write_string_list(mut w, t.block_exclusion_list)
	write_string_list(mut w, t.entity_exclusion_list)
	write_string_list(mut w, t.block_tag_exclusion_list)
	write_string_list(mut w, t.liquid_targeting_list)
	w.write_varuint32(u32(t.item_settings.len))
	for s in t.item_settings {
		s.encode(mut w)
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
	t.block_exclusion_list = read_string_list(mut r)!
	t.entity_exclusion_list = read_string_list(mut r)!
	t.block_tag_exclusion_list = read_string_list(mut r)!
	t.liquid_targeting_list = read_string_list(mut r)!
	count := r.read_count()!
	t.item_settings = []types_766.CameraAimAssistItemSettings{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.item_settings << types_766.CameraAimAssistItemSettings.decode(mut r)!
	}
	if r.bool()! {
		t.default_item_settings = r.read_string()!
	}
	if r.bool()! {
		t.hand_settings = r.read_string()!
	}
	return t
}
