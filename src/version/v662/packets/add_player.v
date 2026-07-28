module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct AddPlayerPacket {
pub mut:
	uuid              types.Uuid
	player_name       string
	target_runtime_id types.ActorRuntimeID
	platform_chat_id  string
	position          [3]f32
	velocity          [3]f32
	rotation          [2]f32
	y_head_rotation   f32
	carried_item      types.NetworkItemStackDescriptor
	player_game_type  enums.GameType
	entity_data       []types.DataItem
	synced_properties types.PropertySyncData
	abilities_data    types.SerializedAbilitiesData
	actor_links       []types.ActorLink
	device_id         string
	build_platform    enums.BuildPlatform
}

pub fn (p &AddPlayerPacket) pid() u16 {
	return 12
}

pub fn (p &AddPlayerPacket) name() string {
	return 'AddPlayerPacket'
}

pub fn (p &AddPlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddPlayerPacket) encode_payload(mut w serializer.Writer) {
	p.uuid.encode(mut w)
	w.write_string(p.player_name)
	p.target_runtime_id.encode(mut w)
	w.write_string(p.platform_chat_id)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	w.le_f32(p.rotation[0])
	w.le_f32(p.rotation[1])
	w.le_f32(p.y_head_rotation)
	p.carried_item.encode(mut w)
	p.player_game_type.encode(mut w)
	w.write_varuint32(u32(p.entity_data.len))
	for e in p.entity_data {
		e.encode(mut w)
	}
	p.synced_properties.encode(mut w)
	p.abilities_data.encode(mut w)
	w.write_varuint32(u32(p.actor_links.len))
	for e in p.actor_links {
		e.encode(mut w)
	}
	w.write_string(p.device_id)
	p.build_platform.encode(mut w)
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.Uuid.decode(mut r)!
	p.player_name = r.read_string()!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.platform_chat_id = r.read_string()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.rotation = [r.le_f32()!, r.le_f32()!]!
	p.y_head_rotation = r.le_f32()!
	p.carried_item = types.NetworkItemStackDescriptor.decode(mut r)!
	p.player_game_type = enums.GameType.decode(mut r)!
	{
		count := int(r.read_varuint32()!)
		p.entity_data = []types.DataItem{cap: count}
		for _ in 0 .. count {
			p.entity_data << types.DataItem.decode(mut r)!
		}
	}
	p.synced_properties = types.PropertySyncData.decode(mut r)!
	p.abilities_data = types.SerializedAbilitiesData.decode(mut r)!
	{
		count := int(r.read_varuint32()!)
		p.actor_links = []types.ActorLink{cap: count}
		for _ in 0 .. count {
			p.actor_links << types.ActorLink.decode(mut r)!
		}
	}
	p.device_id = r.read_string()!
	p.build_platform = enums.BuildPlatform.decode(mut r)!
}
