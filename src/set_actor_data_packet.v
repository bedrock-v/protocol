module protocol

import serializer
import types

pub const meta_key_flags = u32(0)
pub const meta_key_color_index = u32(3)
pub const meta_key_name = u32(4)
pub const meta_key_effect_color = u32(8)
pub const meta_key_effect_ambience = u32(9)
pub const meta_key_width = u32(53)
pub const meta_key_height = u32(54)
pub const meta_key_always_show_name_tag = u32(81)

pub const entity_flag_show_name = 14
pub const entity_flag_always_show_name = 15
pub const entity_flag_can_climb = 19
pub const entity_flag_breathing = 35
pub const entity_flag_has_collision = 48
pub const entity_flag_affected_by_gravity = 49

pub struct SetActorDataPacket {
pub mut:
	actor_runtime_id  u64
	metadata          []types.MetadataEntry
	synced_properties types.PropertySyncData
	tick              u64
}

pub fn (p &SetActorDataPacket) pid() u16 {
	return set_actor_data_packet
}

pub fn (p &SetActorDataPacket) name() string {
	return 'SetActorDataPacket'
}

pub fn (p &SetActorDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetActorDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.metadata = r.read_entity_metadata()!
	p.synced_properties = r.read_property_sync_data()!
	p.tick = r.read_varuint64()!
}

pub fn (p &SetActorDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_entity_metadata(p.metadata)
	w.write_property_sync_data(p.synced_properties)
	w.write_varuint64(p.tick)
}
