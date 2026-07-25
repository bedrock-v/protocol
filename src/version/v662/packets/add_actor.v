module packets

import serializer
import version.v662.types

pub struct AttributeEntry {
pub mut:
	attribute_name string
	min_value      f32
	current_value  f32
	max_value      f32
}

pub fn (e AttributeEntry) encode(mut w serializer.Writer) {
	w.write_string(e.attribute_name)
	w.le_f32(e.min_value)
	w.le_f32(e.current_value)
	w.le_f32(e.max_value)
}

pub fn AttributeEntry.decode(mut r serializer.Reader) !AttributeEntry {
	return AttributeEntry{
		attribute_name: r.read_string()!
		min_value:      r.le_f32()!
		current_value:  r.le_f32()!
		max_value:      r.le_f32()!
	}
}

pub struct AddActorPacket {
pub mut:
	target_actor_id   types.ActorUniqueID
	target_runtime_id types.ActorRuntimeID
	actor_type        string
	position          [3]f32
	velocity          [3]f32
	rotation          [2]f32
	y_head_rotation   f32
	y_body_rotation   f32
	attributes        []AttributeEntry
	actor_data        []types.DataItem
	synced_properties types.PropertySyncData
	actor_links       []types.ActorLink
}

pub fn (p &AddActorPacket) pid() u16 { return 13 }

pub fn (p &AddActorPacket) name() string { return 'AddActorPacket' }

pub fn (p &AddActorPacket) can_be_sent_before_login() bool { return false }

pub fn (p &AddActorPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	p.target_runtime_id.encode(mut w)
	w.write_string(p.actor_type)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	w.le_f32(p.rotation[0])
	w.le_f32(p.rotation[1])
	w.le_f32(p.y_head_rotation)
	w.le_f32(p.y_body_rotation)
	w.write_varuint32(u32(p.attributes.len))
	for e in p.attributes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.actor_data.len))
	for e in p.actor_data {
		e.encode(mut w)
	}
	p.synced_properties.encode(mut w)
	w.write_varuint32(u32(p.actor_links.len))
	for e in p.actor_links {
		e.encode(mut w)
	}
}

pub fn (mut p AddActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.actor_type = r.read_string()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.rotation = [r.le_f32()!, r.le_f32()!]!
	p.y_head_rotation = r.le_f32()!
	p.y_body_rotation = r.le_f32()!
	attr_count := int(r.read_varuint32()!)
	p.attributes = []AttributeEntry{cap: attr_count}
	for _ in 0 .. attr_count {
		p.attributes << AttributeEntry.decode(mut r)!
	}
	data_count := int(r.read_varuint32()!)
	p.actor_data = []types.DataItem{cap: data_count}
	for _ in 0 .. data_count {
		p.actor_data << types.DataItem.decode(mut r)!
	}
	p.synced_properties = types.PropertySyncData.decode(mut r)!
	link_count := int(r.read_varuint32()!)
	p.actor_links = []types.ActorLink{cap: link_count}
	for _ in 0 .. link_count {
		p.actor_links << types.ActorLink.decode(mut r)!
	}
}
