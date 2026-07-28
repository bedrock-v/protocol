module packets

import protocol.serializer
import nbt
import protocol.version.v671.types
import protocol.version.v662.types as types_662
import protocol.version.v662.enums

pub struct BlockProperty {
pub mut:
	block_name       string
	block_definition nbt.RootTag
}

pub fn (e BlockProperty) encode(mut w serializer.Writer) {
	w.write_string(e.block_name)
	w.write_nbt_compound_root(e.block_definition)
}

pub fn BlockProperty.decode(mut r serializer.Reader) !BlockProperty {
	return BlockProperty{
		block_name:       r.read_string()!
		block_definition: r.read_nbt_compound_root()!
	}
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
	movement_settings                     types_662.SyncedPlayerMovementSettings
	current_level_time                    u64
	enchantment_seed                      i32
	block_properties                      []BlockProperty
	item_list                             []types_662.ItemData
	multiplayer_correlation_id            string
	enable_item_stack_net_manager         bool
	server_version                        string
	player_property_data                  nbt.RootTag
	server_block_type_registry_checksum   u64
	world_template_id                     types_662.Uuid
	server_enabled_client_side_generation bool
	block_network_ids_are_hashes          bool
	network_permissions                   types_662.NetworkPermissions
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
	for e in p.block_properties {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.item_list.len))
	for e in p.item_list {
		e.encode(mut w)
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
	p.movement_settings = types_662.SyncedPlayerMovementSettings.decode(mut r)!
	p.current_level_time = r.le_u64()!
	p.enchantment_seed = r.read_varint32()!
	block_count := int(r.read_varuint32()!)
	p.block_properties = []BlockProperty{cap: block_count}
	for _ in 0 .. block_count {
		p.block_properties << BlockProperty.decode(mut r)!
	}
	item_count := int(r.read_varuint32()!)
	p.item_list = []types_662.ItemData{cap: item_count}
	for _ in 0 .. item_count {
		p.item_list << types_662.ItemData.decode(mut r)!
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
}
