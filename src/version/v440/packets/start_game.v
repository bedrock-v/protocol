module packets

import nbt
import serializer
import version.v440.types
import version.v291.types as types_291
import version.v291.enums as enums_291
import version.v291.packets as packets_291
import version.v419.types as types_419

pub enum SpawnBiomeType as i16 {
	default      = 0
	user_defined = 1
}

pub enum AuthoritativeMovementMode as i32 {
	client             = 0
	server             = 1
	server_with_rewind = 2
}

pub struct BlockPropertyData {
pub mut:
	name       string
	properties nbt.RootTag
}

pub struct ItemDefinition {
pub mut:
	identifier      string
	runtime_id      i16
	component_based bool
}

pub struct StartGamePacket {
pub mut:
	unique_entity_id                    i64
	runtime_entity_id                   u64
	player_game_type                    enums_291.GameType
	player_position                     types_291.Vector3f
	rotation                            types_291.Vector2f
	seed                                i64
	spawn_biome_type                    SpawnBiomeType
	custom_biome_name                   string
	dimension_id                        i32
	generator_id                        i32
	level_game_type                     enums_291.GameType
	difficulty                          i32
	default_spawn                       types_291.BlockPosition
	achievements_disabled               bool
	day_cycle_stop_time                 i32
	edu_edition_offers                  i32
	edu_features_enabled                bool
	education_production_id             string
	rain_level                          f32
	lightning_level                     f32
	platform_locked_content_confirmed   bool
	multiplayer_game                    bool
	broadcasting_to_lan                 bool
	xbl_broadcast_mode                  packets_291.GamePublishSetting
	platform_broadcast_mode             packets_291.GamePublishSetting
	commands_enabled                    bool
	texture_packs_required              bool
	gamerules                           []types.GameRuleData
	experiments                         []types_419.ExperimentData
	experiments_previously_toggled      bool
	bonus_chest_enabled                 bool
	starting_with_map                   bool
	default_player_permission           enums_291.PlayerPermission
	server_chunk_tick_range             i32
	behavior_pack_locked                bool
	resource_pack_locked                bool
	from_locked_world_template          bool
	using_msa_gamertags_only            bool
	from_world_template                 bool
	world_template_option_locked        bool
	only_spawning_v1_villagers          bool
	vanilla_version                     string
	limited_world_width                 i32
	limited_world_height                i32
	nether_type                         bool
	force_experimental_gameplay_set     bool
	force_experimental_gameplay         bool
	level_id                            string
	level_name                          string
	premium_world_template_id           string
	trial                               bool
	authoritative_movement_mode         AuthoritativeMovementMode
	rewind_history_size                 i32
	server_authoritative_block_breaking bool
	current_tick                        i64
	enchantment_seed                    i32
	block_properties                    []BlockPropertyData
	item_definitions                    []ItemDefinition
	multiplayer_correlation_id          string
	inventories_server_authoritative    bool
	server_engine                       string
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
	w.le_i16(i16(p.spawn_biome_type))
	w.write_string(p.custom_biome_name)
	w.write_varint32(p.dimension_id)
	w.write_varint32(p.generator_id)
	p.level_game_type.encode(mut w)
	w.write_varint32(p.difficulty)
	p.default_spawn.encode(mut w)
	w.bool(p.achievements_disabled)
	w.write_varint32(p.day_cycle_stop_time)
	w.write_varint32(p.edu_edition_offers)
	w.bool(p.edu_features_enabled)
	w.write_string(p.education_production_id)
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
	types_419.write_experiments(mut w, p.experiments)
	w.bool(p.experiments_previously_toggled)
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
	w.write_string(p.vanilla_version)
	w.le_i32(p.limited_world_width)
	w.le_i32(p.limited_world_height)
	w.bool(p.nether_type)
	w.bool(p.force_experimental_gameplay_set)
	if p.force_experimental_gameplay_set {
		w.bool(p.force_experimental_gameplay)
	}
	w.write_string(p.level_id)
	w.write_string(p.level_name)
	w.write_string(p.premium_world_template_id)
	w.bool(p.trial)
	w.write_varint32(i32(p.authoritative_movement_mode))
	w.write_varint32(p.rewind_history_size)
	w.bool(p.server_authoritative_block_breaking)
	w.le_i64(p.current_tick)
	w.write_varint32(p.enchantment_seed)
	w.write_varuint32(u32(p.block_properties.len))
	for block in p.block_properties {
		w.write_string(block.name)
		w.write_nbt_compound_root(block.properties)
	}
	w.write_varuint32(u32(p.item_definitions.len))
	for item in p.item_definitions {
		w.write_string(item.identifier)
		w.le_i16(item.runtime_id)
		w.bool(item.component_based)
	}
	w.write_string(p.multiplayer_correlation_id)
	w.bool(p.inventories_server_authoritative)
	w.write_string(p.server_engine)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.runtime_entity_id = r.read_varuint64()!
	p.player_game_type = enums_291.GameType.decode(mut r)!
	p.player_position = types_291.Vector3f.decode(mut r)!
	p.rotation = types_291.Vector2f.decode(mut r)!
	p.seed = i64(r.read_varint32()!)
	p.spawn_biome_type = unsafe { SpawnBiomeType(r.le_i16()!) }
	p.custom_biome_name = r.read_string()!
	p.dimension_id = r.read_varint32()!
	p.generator_id = r.read_varint32()!
	p.level_game_type = enums_291.GameType.decode(mut r)!
	p.difficulty = r.read_varint32()!
	p.default_spawn = types_291.BlockPosition.decode(mut r)!
	p.achievements_disabled = r.bool()!
	p.day_cycle_stop_time = r.read_varint32()!
	p.edu_edition_offers = r.read_varint32()!
	p.edu_features_enabled = r.bool()!
	p.education_production_id = r.read_string()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.platform_locked_content_confirmed = r.bool()!
	p.multiplayer_game = r.bool()!
	p.broadcasting_to_lan = r.bool()!
	p.xbl_broadcast_mode = unsafe { packets_291.GamePublishSetting(r.read_varint32()!) }
	p.platform_broadcast_mode = unsafe { packets_291.GamePublishSetting(r.read_varint32()!) }
	p.commands_enabled = r.bool()!
	p.texture_packs_required = r.bool()!
	rule_count := int(r.read_varuint32()!)
	mut gamerules := []types.GameRuleData{cap: rule_count}
	for _ in 0 .. rule_count {
		gamerules << types.GameRuleData.decode(mut r)!
	}
	p.gamerules = gamerules
	p.experiments = types_419.read_experiments(mut r)!
	p.experiments_previously_toggled = r.bool()!
	p.bonus_chest_enabled = r.bool()!
	p.starting_with_map = r.bool()!
	p.default_player_permission = unsafe { enums_291.PlayerPermission(u32(r.read_varint32()!)) }
	p.server_chunk_tick_range = r.le_i32()!
	p.behavior_pack_locked = r.bool()!
	p.resource_pack_locked = r.bool()!
	p.from_locked_world_template = r.bool()!
	p.using_msa_gamertags_only = r.bool()!
	p.from_world_template = r.bool()!
	p.world_template_option_locked = r.bool()!
	p.only_spawning_v1_villagers = r.bool()!
	p.vanilla_version = r.read_string()!
	p.limited_world_width = r.le_i32()!
	p.limited_world_height = r.le_i32()!
	p.nether_type = r.bool()!
	p.force_experimental_gameplay_set = r.bool()!
	if p.force_experimental_gameplay_set {
		p.force_experimental_gameplay = r.bool()!
	}
	p.level_id = r.read_string()!
	p.level_name = r.read_string()!
	p.premium_world_template_id = r.read_string()!
	p.trial = r.bool()!
	p.authoritative_movement_mode = unsafe { AuthoritativeMovementMode(r.read_varint32()!) }
	p.rewind_history_size = r.read_varint32()!
	p.server_authoritative_block_breaking = r.bool()!
	p.current_tick = r.le_i64()!
	p.enchantment_seed = r.read_varint32()!
	block_count := int(r.read_varuint32()!)
	mut blocks := []BlockPropertyData{cap: block_count}
	for _ in 0 .. block_count {
		blocks << BlockPropertyData{
			name:       r.read_string()!
			properties: r.read_nbt_compound_root()!
		}
	}
	p.block_properties = blocks
	item_count := int(r.read_varuint32()!)
	mut items := []ItemDefinition{cap: item_count}
	for _ in 0 .. item_count {
		items << ItemDefinition{
			identifier:      r.read_string()!
			runtime_id:      r.le_i16()!
			component_based: r.bool()!
		}
	}
	p.item_definitions = items
	p.multiplayer_correlation_id = r.read_string()!
	p.inventories_server_authoritative = r.bool()!
	p.server_engine = r.read_string()!
}
