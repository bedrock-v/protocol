module packets

import protocol.serializer
import protocol.version.v291.enums
import protocol.version.v291.packets as packets_291
import protocol.version.v291.types

pub struct BlockPaletteEntry {
pub mut:
	name string
	meta i16
	id   i16
}

pub struct ItemDefinitionEntry {
pub mut:
	identifier string
	runtime_id i16
}

pub struct StartGamePacket {
pub mut:
	unique_entity_id                  i64
	runtime_entity_id                 u64
	player_game_type                  enums.GameType
	player_position                   types.Vector3f
	rotation                          types.Vector2f
	seed                              i64
	dimension_id                      i32
	generator_id                      i32
	level_game_type                   enums.GameType
	difficulty                        i32
	default_spawn                     types.BlockPosition
	achievements_disabled             bool
	day_cycle_stop_time               i32
	edu_edition_offers                i32
	edu_features_enabled              bool
	rain_level                        f32
	lightning_level                   f32
	platform_locked_content_confirmed bool
	multiplayer_game                  bool
	broadcasting_to_lan               bool
	xbl_broadcast_mode                packets_291.GamePublishSetting
	platform_broadcast_mode           packets_291.GamePublishSetting
	commands_enabled                  bool
	texture_packs_required            bool
	gamerules                         []types.GameRuleData
	bonus_chest_enabled               bool
	starting_with_map                 bool
	default_player_permission         enums.PlayerPermission
	server_chunk_tick_range           i32
	behavior_pack_locked              bool
	resource_pack_locked              bool
	from_locked_world_template        bool
	using_msa_gamertags_only          bool
	from_world_template               bool
	world_template_option_locked      bool
	only_spawning_v1_villagers        bool
	level_id                          string
	level_name                        string
	premium_world_template_id         string
	trial                             bool
	current_tick                      i64
	enchantment_seed                  i32
	block_palette                     []BlockPaletteEntry
	item_definitions                  []ItemDefinitionEntry
	multiplayer_correlation_id        string
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
	w.write_varint64(p.unique_entity_id)
	w.write_varuint64(p.runtime_entity_id)
	p.player_game_type.encode(mut w)
	p.player_position.encode(mut w)
	p.rotation.encode(mut w)
	w.write_varint32(i32(p.seed))
	w.write_varint32(p.dimension_id)
	w.write_varint32(p.generator_id)
	p.level_game_type.encode(mut w)
	w.write_varint32(p.difficulty)
	p.default_spawn.encode(mut w)
	w.bool(p.achievements_disabled)
	w.write_varint32(p.day_cycle_stop_time)
	w.bool(p.edu_edition_offers != 0)
	w.bool(p.edu_features_enabled)
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.bool(p.platform_locked_content_confirmed)
	w.bool(p.multiplayer_game)
	w.bool(p.broadcasting_to_lan)
	w.write_varint32(i32(p.xbl_broadcast_mode))
	w.write_varint32(i32(p.platform_broadcast_mode))
	w.bool(p.commands_enabled)
	w.bool(p.texture_packs_required)
	w.write_varuint32(u32(p.gamerules.len))
	for rule in p.gamerules {
		rule.encode(mut w)
	}
	w.bool(p.bonus_chest_enabled)
	w.bool(p.starting_with_map)
	w.write_varint32(i32(p.default_player_permission))
	w.le_i32(p.server_chunk_tick_range)
	w.bool(p.behavior_pack_locked)
	w.bool(p.resource_pack_locked)
	w.bool(p.from_locked_world_template)
	w.bool(p.using_msa_gamertags_only)
	w.bool(p.from_world_template)
	w.bool(p.world_template_option_locked)
	w.bool(p.only_spawning_v1_villagers)
	w.write_string(p.level_id)
	w.write_string(p.level_name)
	w.write_string(p.premium_world_template_id)
	w.bool(p.trial)
	w.le_i64(p.current_tick)
	w.write_varint32(p.enchantment_seed)
	w.write_varuint32(u32(p.block_palette.len))
	for entry in p.block_palette {
		w.write_string(entry.name)
		w.le_i16(entry.meta)
		w.le_i16(entry.id)
	}
	w.write_varuint32(u32(p.item_definitions.len))
	for entry in p.item_definitions {
		w.write_string(entry.identifier)
		w.le_i16(entry.runtime_id)
	}
	w.write_string(p.multiplayer_correlation_id)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.runtime_entity_id = r.read_varuint64()!
	p.player_game_type = enums.GameType.decode(mut r)!
	p.player_position = types.Vector3f.decode(mut r)!
	p.rotation = types.Vector2f.decode(mut r)!
	p.seed = i64(r.read_varint32()!)
	p.dimension_id = r.read_varint32()!
	p.generator_id = r.read_varint32()!
	p.level_game_type = enums.GameType.decode(mut r)!
	p.difficulty = r.read_varint32()!
	p.default_spawn = types.BlockPosition.decode(mut r)!
	p.achievements_disabled = r.bool()!
	p.day_cycle_stop_time = r.read_varint32()!
	p.edu_edition_offers = if r.bool()! { 1 } else { 0 }
	p.edu_features_enabled = r.bool()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.platform_locked_content_confirmed = r.bool()!
	p.multiplayer_game = r.bool()!
	p.broadcasting_to_lan = r.bool()!
	p.xbl_broadcast_mode = unsafe { packets_291.GamePublishSetting(r.read_varint32()!) }
	p.platform_broadcast_mode = unsafe { packets_291.GamePublishSetting(r.read_varint32()!) }
	p.commands_enabled = r.bool()!
	p.texture_packs_required = r.bool()!
	rule_count := r.read_count()!
	mut gamerules := []types.GameRuleData{cap: serializer.prealloc(rule_count)}
	for _ in 0 .. rule_count {
		gamerules << types.GameRuleData.decode(mut r)!
	}
	p.gamerules = gamerules
	p.bonus_chest_enabled = r.bool()!
	p.starting_with_map = r.bool()!
	p.default_player_permission = unsafe { enums.PlayerPermission(u32(r.read_varint32()!)) }
	p.server_chunk_tick_range = r.le_i32()!
	p.behavior_pack_locked = r.bool()!
	p.resource_pack_locked = r.bool()!
	p.from_locked_world_template = r.bool()!
	p.using_msa_gamertags_only = r.bool()!
	p.from_world_template = r.bool()!
	p.world_template_option_locked = r.bool()!
	p.only_spawning_v1_villagers = r.bool()!
	p.level_id = r.read_string()!
	p.level_name = r.read_string()!
	p.premium_world_template_id = r.read_string()!
	p.trial = r.bool()!
	p.current_tick = r.le_i64()!
	p.enchantment_seed = r.read_varint32()!
	palette_count := r.read_count()!
	mut palette := []BlockPaletteEntry{cap: serializer.prealloc(palette_count)}
	for _ in 0 .. palette_count {
		palette << BlockPaletteEntry{
			name: r.read_string()!
			meta: r.le_i16()!
			id:   r.le_i16()!
		}
	}
	p.block_palette = palette
	item_count := r.read_count()!
	mut item_definitions := []ItemDefinitionEntry{cap: serializer.prealloc(item_count)}
	for _ in 0 .. item_count {
		item_definitions << ItemDefinitionEntry{
			identifier: r.read_string()!
			runtime_id: r.le_i16()!
		}
	}
	p.item_definitions = item_definitions
	p.multiplayer_correlation_id = r.read_string()!
}
