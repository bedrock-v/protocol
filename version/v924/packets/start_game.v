module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v662.types as types_662
import protocol.version.v662.enums
import protocol.version.v818.types as types_818
import protocol.version.v924.types

pub struct BlockProperty {
pub mut:
	block_name       string
	block_definition nbt.RootTag
}

pub fn (t BlockProperty) encode(mut w serializer.Writer) {
	w.write_string(t.block_name)
	w.write_nbt_compound_root(t.block_definition)
}

pub fn BlockProperty.decode(mut r serializer.Reader) !BlockProperty {
	return BlockProperty{
		block_name:       r.read_string()!
		block_definition: r.read_nbt_compound_root()!
	}
}

pub struct GatheringJoinInfo {
pub mut:
	experience_id         string
	experience_name       string
	experience_world_id   string
	experience_world_name string
	creator_id            string
	store_id              string
}

pub fn (t GatheringJoinInfo) encode(mut w serializer.Writer) {
	w.write_string(t.experience_id)
	w.write_string(t.experience_name)
	w.write_string(t.experience_world_id)
	w.write_string(t.experience_world_name)
	w.write_string(t.creator_id)
	w.write_string(t.store_id)
}

pub fn GatheringJoinInfo.decode(mut r serializer.Reader) !GatheringJoinInfo {
	return GatheringJoinInfo{
		experience_id:         r.read_string()!
		experience_name:       r.read_string()!
		experience_world_id:   r.read_string()!
		experience_world_name: r.read_string()!
		creator_id:            r.read_string()!
		store_id:              r.read_string()!
	}
}

pub struct ServerJoinInformation {
pub mut:
	gathering_join_info ?GatheringJoinInfo
}

pub fn (t ServerJoinInformation) encode(mut w serializer.Writer) {
	if v := t.gathering_join_info {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn ServerJoinInformation.decode(mut r serializer.Reader) !ServerJoinInformation {
	mut t := ServerJoinInformation{}
	if r.bool()! {
		t.gathering_join_info = GatheringJoinInfo.decode(mut r)!
	}
	return t
}

pub struct StartGamePacket {
pub mut:
	target_actor_id                       types_662.ActorUniqueID
	target_runtime_id                     types_662.ActorRuntimeID
	actor_game_type                       enums.GameType
	position                              [3]f32
	rotation                              [2]f32
	settings                              types.LevelSettings
	level_id                              string
	level_name                            string
	template_content_identity             string
	is_trial                              bool
	movement_settings                     types_818.SyncedPlayerMovementSettings
	current_level_time                    u64
	enchantment_seed                      i32
	block_properties                      []BlockProperty
	multiplayer_correlation_id            string
	enable_item_stack_net_manager         bool
	server_version                        string
	player_property_data                  nbt.RootTag
	server_block_type_registry_checksum   u64
	world_template_id                     types_662.Uuid
	server_enabled_client_side_generation bool
	block_network_ids_are_hashes          bool
	network_permissions                   types_662.NetworkPermissions
	server_join_information               ?ServerJoinInformation
	server_id                             string
	world_id                              string
	scenario_id                           string
	owner_id                              string
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
	p.target_actor_id.encode(mut w)
	p.target_runtime_id.encode(mut w)
	p.actor_game_type.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.rotation[0])
	w.le_f32(p.rotation[1])
	p.settings.encode(mut w)
	w.write_string(p.level_id)
	w.write_string(p.level_name)
	w.write_string(p.template_content_identity)
	w.bool(p.is_trial)
	p.movement_settings.encode(mut w)
	w.le_u64(p.current_level_time)
	w.write_varint32(p.enchantment_seed)
	w.write_varuint32(u32(p.block_properties.len))
	for b in p.block_properties {
		b.encode(mut w)
	}
	w.write_string(p.multiplayer_correlation_id)
	w.bool(p.enable_item_stack_net_manager)
	w.write_string(p.server_version)
	w.write_nbt_compound_root(p.player_property_data)
	w.le_u64(p.server_block_type_registry_checksum)
	p.world_template_id.encode(mut w)
	w.bool(p.server_enabled_client_side_generation)
	w.bool(p.block_network_ids_are_hashes)
	p.network_permissions.encode(mut w)
	if v := p.server_join_information {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.write_string(p.server_id)
	w.write_string(p.world_id)
	w.write_string(p.scenario_id)
	w.write_string(p.owner_id)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types_662.ActorUniqueID.decode(mut r)!
	p.target_runtime_id = types_662.ActorRuntimeID.decode(mut r)!
	p.actor_game_type = enums.GameType.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.rotation = [r.le_f32()!, r.le_f32()!]!
	p.settings = types.LevelSettings.decode(mut r)!
	p.level_id = r.read_string()!
	p.level_name = r.read_string()!
	p.template_content_identity = r.read_string()!
	p.is_trial = r.bool()!
	p.movement_settings = types_818.SyncedPlayerMovementSettings.decode(mut r)!
	p.current_level_time = r.le_u64()!
	p.enchantment_seed = r.read_varint32()!
	block_property_count := r.read_count()!
	p.block_properties = []BlockProperty{cap: serializer.prealloc(block_property_count)}
	for _ in 0 .. block_property_count {
		p.block_properties << BlockProperty.decode(mut r)!
	}
	p.multiplayer_correlation_id = r.read_string()!
	p.enable_item_stack_net_manager = r.bool()!
	p.server_version = r.read_string()!
	p.player_property_data = r.read_nbt_compound_root()!
	p.server_block_type_registry_checksum = r.le_u64()!
	p.world_template_id = types_662.Uuid.decode(mut r)!
	p.server_enabled_client_side_generation = r.bool()!
	p.block_network_ids_are_hashes = r.bool()!
	p.network_permissions = types_662.NetworkPermissions.decode(mut r)!
	if r.bool()! {
		p.server_join_information = ServerJoinInformation.decode(mut r)!
	}
	p.server_id = r.read_string()!
	p.world_id = r.read_string()!
	p.scenario_id = r.read_string()!
	p.owner_id = r.read_string()!
}
