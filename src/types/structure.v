module types

pub struct StructureSettings {
pub mut:
	palette_name             string
	ignore_entities          bool
	ignore_blocks            bool
	allow_non_ticking_chunks bool
	dimensions               BlockPosition
	offset                   BlockPosition
	last_touched_by_player_id i64
	rotation                 u8
	mirror                   u8
	animation_mode           u8
	animation_seconds        f32
	integrity_value          f32
	integrity_seed           u32
	pivot                    Vector3
}

pub struct StructureEditorData {
pub mut:
	structure_name             string
	filtered_structure_name    string
	structure_data_field       string
	include_players            bool
	show_bounding_box          bool
	structure_block_type       int
	structure_settings         StructureSettings
	structure_redstone_save_mode int
}
