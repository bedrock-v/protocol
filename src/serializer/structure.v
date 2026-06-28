module serializer

import types

pub fn (mut r Reader) read_structure_settings() !types.StructureSettings {
	return types.StructureSettings{
		palette_name:              r.read_string()!
		ignore_entities:           r.bool()!
		ignore_blocks:             r.bool()!
		allow_non_ticking_chunks:  r.bool()!
		dimensions:                r.read_block_position()!
		offset:                    r.read_block_position()!
		last_touched_by_player_id: r.read_actor_unique_id()!
		rotation:                  r.u8()!
		mirror:                    r.u8()!
		animation_mode:            r.u8()!
		animation_seconds:         r.le_f32()!
		integrity_value:           r.le_f32()!
		integrity_seed:            r.le_u32()!
		pivot:                     r.read_vector3()!
	}
}

pub fn (mut w Writer) write_structure_settings(s types.StructureSettings) {
	w.write_string(s.palette_name)
	w.bool(s.ignore_entities)
	w.bool(s.ignore_blocks)
	w.bool(s.allow_non_ticking_chunks)
	w.write_block_position(s.dimensions)
	w.write_block_position(s.offset)
	w.write_actor_unique_id(s.last_touched_by_player_id)
	w.u8(s.rotation)
	w.u8(s.mirror)
	w.u8(s.animation_mode)
	w.le_f32(s.animation_seconds)
	w.le_f32(s.integrity_value)
	w.le_u32(s.integrity_seed)
	w.write_vector3(s.pivot)
}

pub fn (mut r Reader) read_structure_editor_data() !types.StructureEditorData {
	mut d := types.StructureEditorData{
		structure_name:          r.read_string()!
		filtered_structure_name: r.read_string()!
		structure_data_field:    r.read_string()!
		include_players:         r.bool()!
		show_bounding_box:       r.bool()!
		structure_block_type:    r.read_varint32()!
	}
	d.structure_settings = r.read_structure_settings()!
	d.structure_redstone_save_mode = r.read_varint32()!
	return d
}

pub fn (mut w Writer) write_structure_editor_data(d types.StructureEditorData) {
	w.write_string(d.structure_name)
	w.write_string(d.filtered_structure_name)
	w.write_string(d.structure_data_field)
	w.bool(d.include_players)
	w.bool(d.show_bounding_box)
	w.write_varint32(d.structure_block_type)
	w.write_structure_settings(d.structure_settings)
	w.write_varint32(d.structure_redstone_save_mode)
}
