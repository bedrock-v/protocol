module protocol

import serializer
import types

pub struct AddPlayerPacket {
pub mut:
	uuid              types.UUID
	username          string
	actor_runtime_id  u64
	platform_chat_id  string
	position          types.Vector3
	motion            types.Vector3
	pitch             f32
	yaw               f32
	head_yaw          f32
	item              types.ItemStackWrapper
	game_mode         int
	metadata          []types.MetadataEntry
	synced_properties types.PropertySyncData
	abilities         AbilitiesData
	links             []types.EntityLink
	device_id         string
	build_platform    i32
}

pub fn (p &AddPlayerPacket) pid() u16 {
	return add_player_packet
}

pub fn (p &AddPlayerPacket) name() string {
	return 'AddPlayerPacket'
}

pub fn (p &AddPlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = r.read_uuid()!
	p.username = r.read_string()!
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.platform_chat_id = r.read_string()!
	p.position = r.read_vector3()!
	p.motion = r.read_vector3()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.head_yaw = r.le_f32()!
	p.item = r.read_item_stack_wrapper()!
	p.game_mode = r.read_varint32()!
	p.metadata = r.read_entity_metadata()!
	p.synced_properties = r.read_property_sync_data()!
	p.abilities = read_abilities_data(mut r)!
	link_count := r.read_varuint32()!
	p.links = []types.EntityLink{}
	for _ in 0 .. link_count {
		p.links << r.read_entity_link()!
	}
	p.device_id = r.read_string()!
	p.build_platform = r.le_i32()!
}

pub fn (p &AddPlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_uuid(p.uuid)
	w.write_string(p.username)
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_string(p.platform_chat_id)
	w.write_vector3(p.position)
	w.write_vector3(p.motion)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.head_yaw)
	w.write_item_stack_wrapper(p.item)
	w.write_varint32(p.game_mode)
	w.write_entity_metadata(p.metadata)
	w.write_property_sync_data(p.synced_properties)
	write_abilities_data(mut w, p.abilities)
	w.write_varuint32(u32(p.links.len))
	for link in p.links {
		w.write_entity_link(link)
	}
	w.write_string(p.device_id)
	w.le_i32(p.build_platform)
}
