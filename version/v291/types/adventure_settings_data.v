module types

import protocol.serializer

pub const adventure_flag_world_immutable = u32(1 << 0)
pub const adventure_flag_no_pvm = u32(1 << 1)
pub const adventure_flag_no_mvp = u32(1 << 2)
pub const adventure_flag_show_name_tags = u32(1 << 4)
pub const adventure_flag_auto_jump = u32(1 << 5)
pub const adventure_flag_may_fly = u32(1 << 6)
pub const adventure_flag_no_clip = u32(1 << 7)
pub const adventure_flag_world_builder = u32(1 << 8)
pub const adventure_flag_flying = u32(1 << 9)
pub const adventure_flag_muted = u32(1 << 10)

pub const ability_mine = u32(1 << 0)
pub const ability_doors_and_switches = u32(1 << 1)
pub const ability_open_containers = u32(1 << 2)
pub const ability_attack_players = u32(1 << 3)
pub const ability_attack_mobs = u32(1 << 4)
pub const ability_operator = u32(1 << 5)
pub const ability_teleport = u32(1 << 7)
pub const ability_build = u32(1 << 8)
pub const ability_default_level_permissions = u32(1 << 9)

pub struct AdventureSettingsData {
pub mut:
	flags1             u32
	command_permission u32
	flags2             u32
	player_permission  u32
	custom_flags       u32
	unique_entity_id   i64
}

pub fn (t AdventureSettingsData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.flags1)
	w.write_varuint32(t.command_permission)
	w.write_varuint32(t.flags2)
	w.write_varuint32(t.player_permission)
	w.write_varuint32(t.custom_flags)
	w.le_i64(t.unique_entity_id)
}

pub fn AdventureSettingsData.decode(mut r serializer.Reader) !AdventureSettingsData {
	return AdventureSettingsData{
		flags1:             r.read_varuint32()!
		command_permission: r.read_varuint32()!
		flags2:             r.read_varuint32()!
		player_permission:  r.read_varuint32()!
		custom_flags:       r.read_varuint32()!
		unique_entity_id:   r.le_i64()!
	}
}
