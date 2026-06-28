module protocol

import serializer
import types
import nbt

pub struct EducationSharedResourceURI {
pub mut:
	button_name string
	link_uri    string
}

pub struct BlockEntry {
pub mut:
	name       string
	properties nbt.RootTag
}

pub struct GatheringJoinInfo {
pub mut:
	experience_id         types.UUID
	experience_name       string
	experience_world_id   types.UUID
	experience_world_name string
	creator_id            string
	target_id             types.UUID
	scenario_id           string
	server_id             string
}

pub struct StoreEntryPointInfo {
pub mut:
	store_id   string
	store_name string
}

pub struct JoinPresenceInfo {
pub mut:
	has_experience_name bool
	experience_name     string
	has_world_name      bool
	world_name          string
	rich_presence_id    string
}

pub struct ServerJoinInformation {
pub mut:
	has_gathering_join_info  bool
	gathering_join_info      GatheringJoinInfo
	has_store_entry_point    bool
	store_entry_point_info   StoreEntryPointInfo
	has_presence_info        bool
	presence_info            JoinPresenceInfo
}

pub struct StartGamePacket {
pub mut:
	entity_unique_id                i64
	entity_runtime_id               u64
	player_game_mode                int
	player_position                 types.Vector3
	pitch                           f32
	yaw                             f32
	world_seed                      i64
	spawn_biome_type                i16
	user_defined_biome_name         string
	dimension                       int
	generator                       int
	world_game_mode                 int
	hardcore                        bool
	difficulty                      int
	world_spawn                     types.BlockPosition
	achievements_disabled           bool
	editor_world_type               int
	created_in_editor               bool
	exported_from_editor            bool
	day_cycle_lock_time             int
	education_edition_offer         int
	education_features_enabled      bool
	education_product_id            string
	rain_level                      f32
	lightning_level                 f32
	confirmed_platform_locked_content bool
	multi_player_game               bool
	lan_broadcast_enabled           bool
	xbl_broadcast_mode              int
	platform_broadcast_mode         int
	commands_enabled                bool
	texture_pack_required           bool
	game_rules                      []types.GameRule
	experiments                     types.Experiments
	bonus_chest_enabled             bool
	start_with_map_enabled          bool
	player_permissions              int
	server_chunk_tick_radius        int
	has_locked_behaviour_pack       bool
	has_locked_texture_pack         bool
	from_locked_world_template      bool
	msa_gamer_tags_only             bool
	from_world_template             bool
	world_template_settings_locked  bool
	only_spawn_v1_villagers         bool
	persona_disabled                bool
	custom_skins_disabled           bool
	emote_chat_muted                bool
	base_game_version               string
	limited_world_width             int
	limited_world_depth             int
	new_nether                      bool
	education_shared_resource_uri   EducationSharedResourceURI
	has_force_experimental_gameplay bool
	force_experimental_gameplay     bool
	chat_restriction_level          u8
	disable_player_interactions     bool
	server_editor_connection_policy int
	allow_anonymous_block_drops     bool
	level_id                        string
	world_name                      string
	template_content_identity       string
	trial                           bool
	rewind_history_size             int
	server_authoritative_block_breaking bool
	time                            i64
	enchantment_seed                int
	blocks                          []BlockEntry
	multi_player_correlation_id     string
	server_authoritative_inventory  bool
	game_version                    string
	property_data                   nbt.RootTag
	server_block_state_checksum     u64
	world_template_id               types.UUID
	client_side_generation          bool
	use_block_network_id_hashes     bool
	server_authoritative_sound      bool
	is_logging_chat                 bool
	has_server_join_information      bool
	server_join_information         ServerJoinInformation
	server_id                       string
	scenario_id                     string
	world_id                        string
	owner_id                        string
}

pub fn (p &StartGamePacket) pid() u16 {
	return start_game_packet
}

pub fn (p &StartGamePacket) name() string {
	return 'StartGamePacket'
}

pub fn (p &StartGamePacket) can_be_sent_before_login() bool {
	return false
}

fn read_server_join_information(mut r serializer.Reader) !ServerJoinInformation {
	mut s := ServerJoinInformation{}
	if r.bool()! {
		s.has_gathering_join_info = true
		s.gathering_join_info = GatheringJoinInfo{
			experience_id:         r.read_uuid()!
			experience_name:       r.read_string()!
			experience_world_id:   r.read_uuid()!
			experience_world_name: r.read_string()!
			creator_id:            r.read_string()!
			target_id:             r.read_uuid()!
			scenario_id:           r.read_string()!
			server_id:             r.read_string()!
		}
	}
	if r.bool()! {
		s.has_store_entry_point = true
		s.store_entry_point_info = StoreEntryPointInfo{
			store_id:   r.read_string()!
			store_name: r.read_string()!
		}
	}
	if r.bool()! {
		s.has_presence_info = true
		mut pi := JoinPresenceInfo{}
		if r.bool()! {
			pi.has_experience_name = true
			pi.experience_name = r.read_string()!
		}
		if r.bool()! {
			pi.has_world_name = true
			pi.world_name = r.read_string()!
		}
		pi.rich_presence_id = r.read_string()!
		s.presence_info = pi
	}
	return s
}

fn write_server_join_information(mut w serializer.Writer, s ServerJoinInformation) {
	if s.has_gathering_join_info {
		w.bool(true)
		g := s.gathering_join_info
		w.write_uuid(g.experience_id)
		w.write_string(g.experience_name)
		w.write_uuid(g.experience_world_id)
		w.write_string(g.experience_world_name)
		w.write_string(g.creator_id)
		w.write_uuid(g.target_id)
		w.write_string(g.scenario_id)
		w.write_string(g.server_id)
	} else {
		w.bool(false)
	}
	if s.has_store_entry_point {
		w.bool(true)
		w.write_string(s.store_entry_point_info.store_id)
		w.write_string(s.store_entry_point_info.store_name)
	} else {
		w.bool(false)
	}
	if s.has_presence_info {
		w.bool(true)
		pi := s.presence_info
		if pi.has_experience_name {
			w.bool(true)
			w.write_string(pi.experience_name)
		} else {
			w.bool(false)
		}
		if pi.has_world_name {
			w.bool(true)
			w.write_string(pi.world_name)
		} else {
			w.bool(false)
		}
		w.write_string(pi.rich_presence_id)
	} else {
		w.bool(false)
	}
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.player_game_mode = r.read_varint32()!
	p.player_position = r.read_vector3()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.world_seed = r.le_i64()!
	p.spawn_biome_type = r.le_i16()!
	p.user_defined_biome_name = r.read_string()!
	p.dimension = r.read_varint32()!
	p.generator = r.read_varint32()!
	p.world_game_mode = r.read_varint32()!
	p.hardcore = r.bool()!
	p.difficulty = r.read_varint32()!
	p.world_spawn = r.read_block_position()!
	p.achievements_disabled = r.bool()!
	p.editor_world_type = r.read_varint32()!
	p.created_in_editor = r.bool()!
	p.exported_from_editor = r.bool()!
	p.day_cycle_lock_time = r.read_varint32()!
	p.education_edition_offer = r.read_varint32()!
	p.education_features_enabled = r.bool()!
	p.education_product_id = r.read_string()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.confirmed_platform_locked_content = r.bool()!
	p.multi_player_game = r.bool()!
	p.lan_broadcast_enabled = r.bool()!
	p.xbl_broadcast_mode = r.read_varint32()!
	p.platform_broadcast_mode = r.read_varint32()!
	p.commands_enabled = r.bool()!
	p.texture_pack_required = r.bool()!
	p.game_rules = r.read_game_rules(true)!
	p.experiments = r.read_experiments()!
	p.bonus_chest_enabled = r.bool()!
	p.start_with_map_enabled = r.bool()!
	p.player_permissions = r.read_varint32()!
	p.server_chunk_tick_radius = r.le_i32()!
	p.has_locked_behaviour_pack = r.bool()!
	p.has_locked_texture_pack = r.bool()!
	p.from_locked_world_template = r.bool()!
	p.msa_gamer_tags_only = r.bool()!
	p.from_world_template = r.bool()!
	p.world_template_settings_locked = r.bool()!
	p.only_spawn_v1_villagers = r.bool()!
	p.persona_disabled = r.bool()!
	p.custom_skins_disabled = r.bool()!
	p.emote_chat_muted = r.bool()!
	p.base_game_version = r.read_string()!
	p.limited_world_width = r.le_i32()!
	p.limited_world_depth = r.le_i32()!
	p.new_nether = r.bool()!
	p.education_shared_resource_uri = EducationSharedResourceURI{
		button_name: r.read_string()!
		link_uri:    r.read_string()!
	}
	if r.bool()! {
		p.has_force_experimental_gameplay = true
		p.force_experimental_gameplay = r.bool()!
	}
	p.chat_restriction_level = r.u8()!
	p.disable_player_interactions = r.bool()!
	p.server_editor_connection_policy = r.read_varint32()!
	p.allow_anonymous_block_drops = r.bool()!
	p.level_id = r.read_string()!
	p.world_name = r.read_string()!
	p.template_content_identity = r.read_string()!
	p.trial = r.bool()!
	p.rewind_history_size = r.read_varint32()!
	p.server_authoritative_block_breaking = r.bool()!
	p.time = r.le_i64()!
	p.enchantment_seed = r.read_varint32()!
	block_count := r.read_varuint32()!
	p.blocks = []BlockEntry{}
	for _ in 0 .. block_count {
		p.blocks << BlockEntry{
			name:       r.read_string()!
			properties: r.read_nbt_compound_root()!
		}
	}
	p.multi_player_correlation_id = r.read_string()!
	p.server_authoritative_inventory = r.bool()!
	p.game_version = r.read_string()!
	p.property_data = r.read_nbt_compound_root()!
	p.server_block_state_checksum = r.le_u64()!
	p.world_template_id = r.read_uuid()!
	p.client_side_generation = r.bool()!
	p.use_block_network_id_hashes = r.bool()!
	p.server_authoritative_sound = r.bool()!
	p.is_logging_chat = r.bool()!
	if r.bool()! {
		p.has_server_join_information = true
		p.server_join_information = read_server_join_information(mut r)!
	}
	p.server_id = r.read_string()!
	p.scenario_id = r.read_string()!
	p.world_id = r.read_string()!
	p.owner_id = r.read_string()!
}

pub fn (p &StartGamePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	w.write_varint32(p.player_game_mode)
	w.write_vector3(p.player_position)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_i64(p.world_seed)
	w.le_i16(p.spawn_biome_type)
	w.write_string(p.user_defined_biome_name)
	w.write_varint32(p.dimension)
	w.write_varint32(p.generator)
	w.write_varint32(p.world_game_mode)
	w.bool(p.hardcore)
	w.write_varint32(p.difficulty)
	w.write_block_position(p.world_spawn)
	w.bool(p.achievements_disabled)
	w.write_varint32(p.editor_world_type)
	w.bool(p.created_in_editor)
	w.bool(p.exported_from_editor)
	w.write_varint32(p.day_cycle_lock_time)
	w.write_varint32(p.education_edition_offer)
	w.bool(p.education_features_enabled)
	w.write_string(p.education_product_id)
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.bool(p.confirmed_platform_locked_content)
	w.bool(p.multi_player_game)
	w.bool(p.lan_broadcast_enabled)
	w.write_varint32(p.xbl_broadcast_mode)
	w.write_varint32(p.platform_broadcast_mode)
	w.bool(p.commands_enabled)
	w.bool(p.texture_pack_required)
	w.write_game_rules(p.game_rules, true)
	w.write_experiments(p.experiments)
	w.bool(p.bonus_chest_enabled)
	w.bool(p.start_with_map_enabled)
	w.write_varint32(p.player_permissions)
	w.le_i32(p.server_chunk_tick_radius)
	w.bool(p.has_locked_behaviour_pack)
	w.bool(p.has_locked_texture_pack)
	w.bool(p.from_locked_world_template)
	w.bool(p.msa_gamer_tags_only)
	w.bool(p.from_world_template)
	w.bool(p.world_template_settings_locked)
	w.bool(p.only_spawn_v1_villagers)
	w.bool(p.persona_disabled)
	w.bool(p.custom_skins_disabled)
	w.bool(p.emote_chat_muted)
	w.write_string(p.base_game_version)
	w.le_i32(p.limited_world_width)
	w.le_i32(p.limited_world_depth)
	w.bool(p.new_nether)
	w.write_string(p.education_shared_resource_uri.button_name)
	w.write_string(p.education_shared_resource_uri.link_uri)
	if p.has_force_experimental_gameplay {
		w.bool(true)
		w.bool(p.force_experimental_gameplay)
	} else {
		w.bool(false)
	}
	w.u8(p.chat_restriction_level)
	w.bool(p.disable_player_interactions)
	w.write_varint32(p.server_editor_connection_policy)
	w.bool(p.allow_anonymous_block_drops)
	w.write_string(p.level_id)
	w.write_string(p.world_name)
	w.write_string(p.template_content_identity)
	w.bool(p.trial)
	w.write_varint32(p.rewind_history_size)
	w.bool(p.server_authoritative_block_breaking)
	w.le_i64(p.time)
	w.write_varint32(p.enchantment_seed)
	w.write_varuint32(u32(p.blocks.len))
	for b in p.blocks {
		w.write_string(b.name)
		w.write_nbt_compound_root(b.properties)
	}
	w.write_string(p.multi_player_correlation_id)
	w.bool(p.server_authoritative_inventory)
	w.write_string(p.game_version)
	w.write_nbt_compound_root(p.property_data)
	w.le_u64(p.server_block_state_checksum)
	w.write_uuid(p.world_template_id)
	w.bool(p.client_side_generation)
	w.bool(p.use_block_network_id_hashes)
	w.bool(p.server_authoritative_sound)
	w.bool(p.is_logging_chat)
	if p.has_server_join_information {
		w.bool(true)
		write_server_join_information(mut w, p.server_join_information)
	} else {
		w.bool(false)
	}
	w.write_string(p.server_id)
	w.write_string(p.scenario_id)
	w.write_string(p.world_id)
	w.write_string(p.owner_id)
}
