module packets

import serializer
import version.v137.types

pub struct EntityAttribute {
pub mut:
	name    string
	min     f32
	current f32
	max     f32
}

pub struct AddEntityPacket {
pub mut:
	entity_unique_id  i64
	entity_runtime_id u64
	entity_type       u32
	position          types.Vector3f
	motion            types.Vector3f
	pitch             f32
	yaw               f32
	head_yaw          f32
	attributes        []EntityAttribute
	metadata          []types.DataItem
	links             []types.EntityLink
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 13
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	w.write_varuint32(p.entity_type)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.head_yaw)
	w.write_varuint32(u32(p.attributes.len))
	for attribute in p.attributes {
		w.write_string(attribute.name)
		w.le_f32(attribute.min)
		w.le_f32(attribute.current)
		w.le_f32(attribute.max)
	}
	types.write_entity_data(mut w, p.metadata)
	w.write_varuint32(u32(p.links.len))
	for link in p.links {
		link.encode(mut w)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.entity_type = r.read_varuint32()!
	p.position = types.Vector3f.decode(mut r)!
	p.motion = types.Vector3f.decode(mut r)!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.head_yaw = r.le_f32()!
	attribute_count := int(r.read_varuint32()!)
	p.attributes = []EntityAttribute{cap: attribute_count}
	for _ in 0 .. attribute_count {
		p.attributes << EntityAttribute{
			name:    r.read_string()!
			min:     r.le_f32()!
			current: r.le_f32()!
			max:     r.le_f32()!
		}
	}
	p.metadata = types.read_entity_data(mut r)!
	link_count := int(r.read_varuint32()!)
	p.links = []types.EntityLink{cap: link_count}
	for _ in 0 .. link_count {
		p.links << types.EntityLink.decode(mut r)!
	}
}
