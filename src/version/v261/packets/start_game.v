module packets

import serializer
import version.v137.types

pub struct StartGamePacket {
pub mut:
	entity_unique_id              i64
	entity_runtime_id             u64
	player_gamemode               i32
	player_position               types.Vector3f
	pitch                         f32
	yaw                           f32
	seed                          i32
	dimension                     i32
	generator                     i32
	world_gamemode                i32
	difficulty                    i32
	spawn_position                types.BlockPosition
	has_achievements_disabled     bool
	time                          i32
	edu_mode                      bool
	has_edu_features_enabled      bool
	rain_level                    f32
	lightning_level               f32
	is_multiplayer_game           bool
	has_lan_broadcast             bool
	has_xbox_live_broadcast       bool
	commands_enabled              bool
	is_texture_packs_required     bool
	game_rules                    []types.GameRule
	has_bonus_chest_enabled       bool
	has_start_with_map_enabled    bool
	has_trust_players_enabled     bool
	default_player_permission     i32
	xbox_live_broadcast_mode      i32
	server_chunk_tick_radius      i32
	has_platform_broadcast        bool
	platform_broadcast_mode       i32
	xbox_live_broadcast_intent    bool
	has_locked_behavior_pack      bool
	has_locked_resource_pack      bool
	is_from_locked_world_template bool
	level_id                      string
	world_name                    string
	premium_world_template_id     string
	is_trial                      bool
	current_tick                  i64
	enchantment_seed              i32
}

pub fn (p &StartGamePacket) pid() u16 {
	return 11
}

pub fn (p &StartGamePacket) name() string {
	return 'StartGamePacket'
}

pub fn (p &StartGamePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StartGamePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	w.write_varint32(p.player_gamemode)
	p.player_position.encode(mut w)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.write_varint32(p.seed)
	w.write_varint32(p.dimension)
	w.write_varint32(p.generator)
	w.write_varint32(p.world_gamemode)
	w.write_varint32(p.difficulty)
	p.spawn_position.encode(mut w)
	w.bool(p.has_achievements_disabled)
	w.write_varint32(p.time)
	w.bool(p.edu_mode)
	w.bool(p.has_edu_features_enabled)
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.bool(p.is_multiplayer_game)
	w.bool(p.has_lan_broadcast)
	w.bool(p.has_xbox_live_broadcast)
	w.bool(p.commands_enabled)
	w.bool(p.is_texture_packs_required)
	types.write_game_rules(mut w, p.game_rules)
	w.bool(p.has_bonus_chest_enabled)
	w.bool(p.has_start_with_map_enabled)
	w.bool(p.has_trust_players_enabled)
	w.write_varint32(p.default_player_permission)
	w.write_varint32(p.xbox_live_broadcast_mode)
	w.le_i32(p.server_chunk_tick_radius)
	w.bool(p.has_platform_broadcast)
	w.write_varint32(p.platform_broadcast_mode)
	w.bool(p.xbox_live_broadcast_intent)
	w.bool(p.has_locked_behavior_pack)
	w.bool(p.has_locked_resource_pack)
	w.bool(p.is_from_locked_world_template)
	w.write_string(p.level_id)
	w.write_string(p.world_name)
	w.write_string(p.premium_world_template_id)
	w.bool(p.is_trial)
	w.le_i64(p.current_tick)
	w.write_varint32(p.enchantment_seed)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.player_gamemode = r.read_varint32()!
	p.player_position = types.Vector3f.decode(mut r)!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.seed = r.read_varint32()!
	p.dimension = r.read_varint32()!
	p.generator = r.read_varint32()!
	p.world_gamemode = r.read_varint32()!
	p.difficulty = r.read_varint32()!
	p.spawn_position = types.BlockPosition.decode(mut r)!
	p.has_achievements_disabled = r.bool()!
	p.time = r.read_varint32()!
	p.edu_mode = r.bool()!
	p.has_edu_features_enabled = r.bool()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.is_multiplayer_game = r.bool()!
	p.has_lan_broadcast = r.bool()!
	p.has_xbox_live_broadcast = r.bool()!
	p.commands_enabled = r.bool()!
	p.is_texture_packs_required = r.bool()!
	p.game_rules = types.read_game_rules(mut r)!
	p.has_bonus_chest_enabled = r.bool()!
	p.has_start_with_map_enabled = r.bool()!
	p.has_trust_players_enabled = r.bool()!
	p.default_player_permission = r.read_varint32()!
	p.xbox_live_broadcast_mode = r.read_varint32()!
	p.server_chunk_tick_radius = r.le_i32()!
	p.has_platform_broadcast = r.bool()!
	p.platform_broadcast_mode = r.read_varint32()!
	p.xbox_live_broadcast_intent = r.bool()!
	p.has_locked_behavior_pack = r.bool()!
	p.has_locked_resource_pack = r.bool()!
	p.is_from_locked_world_template = r.bool()!
	p.level_id = r.read_string()!
	p.world_name = r.read_string()!
	p.premium_world_template_id = r.read_string()!
	p.is_trial = r.bool()!
	p.current_tick = r.le_i64()!
	p.enchantment_seed = r.read_varint32()!
}
