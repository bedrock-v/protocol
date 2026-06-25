module src

import src.serializer
import src.types

pub struct AddActorPacket {
pub mut:
	actor_unique_id   i64
	actor_runtime_id  u64
	type              string
	position          types.Vector3
	motion            types.Vector3
	pitch             f32
	yaw               f32
	head_yaw          f32
	body_yaw          f32
	attributes        []types.ActorAttribute
	metadata          []types.MetadataEntry
	synced_properties types.PropertySyncData
	links             []types.EntityLink
}

pub fn (p &AddActorPacket) pid() u16 {
	return add_actor_packet
}

pub fn (p &AddActorPacket) name() string {
	return 'AddActorPacket'
}

pub fn (p &AddActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AddActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.type = r.read_string()!
	p.position = r.read_vector3()!
	p.motion = r.read_vector3()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.head_yaw = r.le_f32()!
	p.body_yaw = r.le_f32()!

	attr_count := int(r.read_varuint32()!)
	p.attributes = []types.ActorAttribute{cap: attr_count}
	for _ in 0 .. attr_count {
		p.attributes << types.ActorAttribute{
			id:      r.read_string()!
			min:     r.le_f32()!
			current: r.le_f32()!
			max:     r.le_f32()!
		}
	}

	p.metadata = r.read_entity_metadata()!
	p.synced_properties = r.read_property_sync_data()!

	link_count := int(r.read_varuint32()!)
	p.links = []types.EntityLink{cap: link_count}
	for _ in 0 .. link_count {
		p.links << r.read_entity_link()!
	}
}

pub fn (p &AddActorPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_string(p.type)
	w.write_vector3(p.position)
	w.write_vector3(p.motion)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.head_yaw)
	w.le_f32(p.body_yaw)

	w.write_varuint32(u32(p.attributes.len))
	for attr in p.attributes {
		w.write_string(attr.id)
		w.le_f32(attr.min)
		w.le_f32(attr.current)
		w.le_f32(attr.max)
	}

	w.write_entity_metadata(p.metadata)
	w.write_property_sync_data(p.synced_properties)

	w.write_varuint32(u32(p.links.len))
	for link in p.links {
		w.write_entity_link(link)
	}
}
