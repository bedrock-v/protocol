module src

import src.serializer

pub struct CameraAimAssistPriority {
pub mut:
	identifier string
	priority   int
}

pub struct CameraAimAssistPriorities {
pub mut:
	entities             []CameraAimAssistPriority
	blocks               []CameraAimAssistPriority
	block_tags           []CameraAimAssistPriority
	entity_type_families []CameraAimAssistPriority
	has_entity_default   bool
	entity_default       int
	has_block_default    bool
	block_default        int
}

pub struct CameraAimAssistCategory {
pub mut:
	name       string
	priorities CameraAimAssistPriorities
}

pub struct CameraAimAssistItemSettings {
pub mut:
	item     string
	category string
}

pub struct CameraAimAssistPreset {
pub mut:
	identifier                    string
	block_exclusions              []string
	entity_exclusions             []string
	block_tag_exclusions          []string
	entity_type_family_exclusions []string
	liquid_targets                []string
	item_settings                 []CameraAimAssistItemSettings
	has_default_item_settings     bool
	default_item_settings         string
	has_hand_settings             bool
	hand_settings                 string
}

pub struct CameraAimAssistPresetsPacket {
pub mut:
	categories []CameraAimAssistCategory
	presets    []CameraAimAssistPreset
	operation  u8
}

pub fn (p &CameraAimAssistPresetsPacket) pid() u16 {
	return camera_aim_assist_presets_packet
}

pub fn (p &CameraAimAssistPresetsPacket) name() string {
	return 'CameraAimAssistPresetsPacket'
}

pub fn (p &CameraAimAssistPresetsPacket) can_be_sent_before_login() bool {
	return false
}

fn read_string_list(mut r serializer.Reader) ![]string {
	count := r.read_varuint32()!
	mut out := []string{}
	for _ in 0 .. count {
		out << r.read_string()!
	}
	return out
}

fn write_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

fn read_aim_assist_priority_list(mut r serializer.Reader) ![]CameraAimAssistPriority {
	count := r.read_varuint32()!
	mut out := []CameraAimAssistPriority{}
	for _ in 0 .. count {
		out << CameraAimAssistPriority{
			identifier: r.read_string()!
			priority:   r.le_i32()!
		}
	}
	return out
}

fn write_aim_assist_priority_list(mut w serializer.Writer, list []CameraAimAssistPriority) {
	w.write_varuint32(u32(list.len))
	for e in list {
		w.write_string(e.identifier)
		w.le_i32(e.priority)
	}
}

fn read_aim_assist_priorities(mut r serializer.Reader) !CameraAimAssistPriorities {
	mut pr := CameraAimAssistPriorities{
		entities:             read_aim_assist_priority_list(mut r)!
		blocks:               read_aim_assist_priority_list(mut r)!
		block_tags:           read_aim_assist_priority_list(mut r)!
		entity_type_families: read_aim_assist_priority_list(mut r)!
	}
	if r.bool()! {
		pr.has_entity_default = true
		pr.entity_default = r.le_i32()!
	}
	if r.bool()! {
		pr.has_block_default = true
		pr.block_default = r.le_i32()!
	}
	return pr
}

fn write_aim_assist_priorities(mut w serializer.Writer, pr CameraAimAssistPriorities) {
	write_aim_assist_priority_list(mut w, pr.entities)
	write_aim_assist_priority_list(mut w, pr.blocks)
	write_aim_assist_priority_list(mut w, pr.block_tags)
	write_aim_assist_priority_list(mut w, pr.entity_type_families)
	if pr.has_entity_default {
		w.bool(true)
		w.le_i32(pr.entity_default)
	} else {
		w.bool(false)
	}
	if pr.has_block_default {
		w.bool(true)
		w.le_i32(pr.block_default)
	} else {
		w.bool(false)
	}
}

fn read_aim_assist_preset(mut r serializer.Reader) !CameraAimAssistPreset {
	mut pre := CameraAimAssistPreset{
		identifier:                    r.read_string()!
		block_exclusions:              read_string_list(mut r)!
		entity_exclusions:             read_string_list(mut r)!
		block_tag_exclusions:          read_string_list(mut r)!
		entity_type_family_exclusions: read_string_list(mut r)!
		liquid_targets:                read_string_list(mut r)!
	}
	settings_count := r.read_varuint32()!
	pre.item_settings = []CameraAimAssistItemSettings{}
	for _ in 0 .. settings_count {
		pre.item_settings << CameraAimAssistItemSettings{
			item:     r.read_string()!
			category: r.read_string()!
		}
	}
	if r.bool()! {
		pre.has_default_item_settings = true
		pre.default_item_settings = r.read_string()!
	}
	if r.bool()! {
		pre.has_hand_settings = true
		pre.hand_settings = r.read_string()!
	}
	return pre
}

fn write_aim_assist_preset(mut w serializer.Writer, pre CameraAimAssistPreset) {
	w.write_string(pre.identifier)
	write_string_list(mut w, pre.block_exclusions)
	write_string_list(mut w, pre.entity_exclusions)
	write_string_list(mut w, pre.block_tag_exclusions)
	write_string_list(mut w, pre.entity_type_family_exclusions)
	write_string_list(mut w, pre.liquid_targets)
	w.write_varuint32(u32(pre.item_settings.len))
	for s in pre.item_settings {
		w.write_string(s.item)
		w.write_string(s.category)
	}
	if pre.has_default_item_settings {
		w.bool(true)
		w.write_string(pre.default_item_settings)
	} else {
		w.bool(false)
	}
	if pre.has_hand_settings {
		w.bool(true)
		w.write_string(pre.hand_settings)
	} else {
		w.bool(false)
	}
}

pub fn (mut p CameraAimAssistPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	cat_count := r.read_varuint32()!
	p.categories = []CameraAimAssistCategory{}
	for _ in 0 .. cat_count {
		p.categories << CameraAimAssistCategory{
			name:       r.read_string()!
			priorities: read_aim_assist_priorities(mut r)!
		}
	}
	preset_count := r.read_varuint32()!
	p.presets = []CameraAimAssistPreset{}
	for _ in 0 .. preset_count {
		p.presets << read_aim_assist_preset(mut r)!
	}
	p.operation = r.u8()!
}

pub fn (p &CameraAimAssistPresetsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.categories.len))
	for c in p.categories {
		w.write_string(c.name)
		write_aim_assist_priorities(mut w, c.priorities)
	}
	w.write_varuint32(u32(p.presets.len))
	for pre in p.presets {
		write_aim_assist_preset(mut w, pre)
	}
	w.u8(p.operation)
}
