module types

import serializer
import version.v662.types as types_662
import version.v662.enums

pub struct LevelSettings {
pub mut:
	seed                                  u64
	spawn_settings                        types_662.SpawnSettings
	generator_type                        enums.GeneratorType
	game_type                             enums.GameType
	is_hardcore_enabled                   bool
	game_difficulty                       enums.Difficulty
	default_spawn_block_position          types_662.NetworkBlockPosition
	achievements_disabled                 bool
	editor_world_type                     enums.EditorWorldType
	is_created_in_editor                  bool
	is_exported_from_editor               bool
	day_cycle_stop_time                   i32
	education_edition_offer               enums.EducationEditionOffer
	education_features_enabled            bool
	education_product_id                  string
	rain_level                            f32
	lightning_level                       f32
	has_confirmed_platform_locked_content bool
	multiplayer_enabled                   bool
	lan_broadcasting_enabled              bool
	xbox_live_broadcast_setting           enums.GamePublishSetting
	platform_broadcast_setting            enums.GamePublishSetting
	commands_enabled                      bool
	texture_packs_required                bool
	rule_data                             types_662.GameRulesChangedPacketData
	experiments                           types_662.Experiments
	bonus_chest_enabled                   bool
	starting_map_enabled                  bool
	player_permissions                    enums.PlayerPermissionLevel
	server_chunk_tick_range               i32
	locked_behaviour_pack                 bool
	locked_resource_pack                  bool
	from_locked_template                  bool
	use_msa_gamer_tags                    bool
	from_template                         bool
	has_locked_template_settings          bool
	only_spawn_v1_villagers               bool
	persona_disabled                      bool
	custom_skins_disabled                 bool
	emote_chat_muted                      bool
	base_game_version                     types_662.BaseGameVersion
	limited_world_width                   i32
	limited_world_depth                   i32
	nether_type                           bool
	edu_shared_uri_resource               types_662.EduSharedUriResource
	override_force_experimental_gameplay  ?bool
	chat_restriction_level                enums.ChatRestrictionLevel
	disable_player_interactions           bool
	server_id                             string
	world_id                              string
	scenario_id                           string
	owner_id                              string
}

pub fn (t LevelSettings) encode(mut w serializer.Writer) {
	w.le_u64(t.seed)
	t.spawn_settings.encode(mut w)
	t.generator_type.encode(mut w)
	t.game_type.encode(mut w)
	w.bool(t.is_hardcore_enabled)
	t.game_difficulty.encode(mut w)
	t.default_spawn_block_position.encode(mut w)
	w.bool(t.achievements_disabled)
	t.editor_world_type.encode(mut w)
	w.bool(t.is_created_in_editor)
	w.bool(t.is_exported_from_editor)
	w.write_varint32(t.day_cycle_stop_time)
	t.education_edition_offer.encode(mut w)
	w.bool(t.education_features_enabled)
	w.write_string(t.education_product_id)
	w.le_f32(t.rain_level)
	w.le_f32(t.lightning_level)
	w.bool(t.has_confirmed_platform_locked_content)
	w.bool(t.multiplayer_enabled)
	w.bool(t.lan_broadcasting_enabled)
	t.xbox_live_broadcast_setting.encode(mut w)
	t.platform_broadcast_setting.encode(mut w)
	w.bool(t.commands_enabled)
	w.bool(t.texture_packs_required)
	t.rule_data.encode(mut w)
	t.experiments.encode(mut w)
	w.bool(t.bonus_chest_enabled)
	w.bool(t.starting_map_enabled)
	t.player_permissions.encode(mut w)
	w.le_i32(t.server_chunk_tick_range)
	w.bool(t.locked_behaviour_pack)
	w.bool(t.locked_resource_pack)
	w.bool(t.from_locked_template)
	w.bool(t.use_msa_gamer_tags)
	w.bool(t.from_template)
	w.bool(t.has_locked_template_settings)
	w.bool(t.only_spawn_v1_villagers)
	w.bool(t.persona_disabled)
	w.bool(t.custom_skins_disabled)
	w.bool(t.emote_chat_muted)
	t.base_game_version.encode(mut w)
	w.le_i32(t.limited_world_width)
	w.le_i32(t.limited_world_depth)
	w.bool(t.nether_type)
	t.edu_shared_uri_resource.encode(mut w)
	if v := t.override_force_experimental_gameplay {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	t.chat_restriction_level.encode(mut w)
	w.bool(t.disable_player_interactions)
	w.write_string(t.server_id)
	w.write_string(t.world_id)
	w.write_string(t.scenario_id)
	w.write_string(t.owner_id)
}

pub fn LevelSettings.decode(mut r serializer.Reader) !LevelSettings {
	mut t := LevelSettings{}
	t.seed = r.le_u64()!
	t.spawn_settings = types_662.SpawnSettings.decode(mut r)!
	t.generator_type = enums.GeneratorType.decode(mut r)!
	t.game_type = enums.GameType.decode(mut r)!
	t.is_hardcore_enabled = r.bool()!
	t.game_difficulty = enums.Difficulty.decode(mut r)!
	t.default_spawn_block_position = types_662.NetworkBlockPosition.decode(mut r)!
	t.achievements_disabled = r.bool()!
	t.editor_world_type = enums.EditorWorldType.decode(mut r)!
	t.is_created_in_editor = r.bool()!
	t.is_exported_from_editor = r.bool()!
	t.day_cycle_stop_time = r.read_varint32()!
	t.education_edition_offer = enums.EducationEditionOffer.decode(mut r)!
	t.education_features_enabled = r.bool()!
	t.education_product_id = r.read_string()!
	t.rain_level = r.le_f32()!
	t.lightning_level = r.le_f32()!
	t.has_confirmed_platform_locked_content = r.bool()!
	t.multiplayer_enabled = r.bool()!
	t.lan_broadcasting_enabled = r.bool()!
	t.xbox_live_broadcast_setting = enums.GamePublishSetting.decode(mut r)!
	t.platform_broadcast_setting = enums.GamePublishSetting.decode(mut r)!
	t.commands_enabled = r.bool()!
	t.texture_packs_required = r.bool()!
	t.rule_data = types_662.GameRulesChangedPacketData.decode(mut r)!
	t.experiments = types_662.Experiments.decode(mut r)!
	t.bonus_chest_enabled = r.bool()!
	t.starting_map_enabled = r.bool()!
	t.player_permissions = enums.PlayerPermissionLevel.decode(mut r)!
	t.server_chunk_tick_range = r.le_i32()!
	t.locked_behaviour_pack = r.bool()!
	t.locked_resource_pack = r.bool()!
	t.from_locked_template = r.bool()!
	t.use_msa_gamer_tags = r.bool()!
	t.from_template = r.bool()!
	t.has_locked_template_settings = r.bool()!
	t.only_spawn_v1_villagers = r.bool()!
	t.persona_disabled = r.bool()!
	t.custom_skins_disabled = r.bool()!
	t.emote_chat_muted = r.bool()!
	t.base_game_version = types_662.BaseGameVersion.decode(mut r)!
	t.limited_world_width = r.le_i32()!
	t.limited_world_depth = r.le_i32()!
	t.nether_type = r.bool()!
	t.edu_shared_uri_resource = types_662.EduSharedUriResource.decode(mut r)!
	if r.bool()! {
		t.override_force_experimental_gameplay = r.bool()!
	}
	t.chat_restriction_level = enums.ChatRestrictionLevel.decode(mut r)!
	t.disable_player_interactions = r.bool()!
	t.server_id = r.read_string()!
	t.world_id = r.read_string()!
	t.scenario_id = r.read_string()!
	t.owner_id = r.read_string()!
	return t
}
