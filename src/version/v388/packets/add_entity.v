module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v388.types

pub struct AddEntityPacket {
pub mut:
	unique_entity_id  i64
	runtime_entity_id u64
	identifier        string
	position          types_291.Vector3f
	motion            types_291.Vector3f
	rotation          types_291.Vector2f
	head_rotation     f32
	attributes        []types_291.AttributeData
	metadata          []types.DataItem
	entity_links      []types_291.EntityLinkData
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
	w.write_varint64(p.unique_entity_id)
	w.write_varuint64(p.runtime_entity_id)
	w.write_string(p.identifier)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	p.rotation.encode(mut w)
	w.le_f32(p.head_rotation)
	w.write_varuint32(u32(p.attributes.len))
	for attribute in p.attributes {
		attribute.encode_entity(mut w)
	}
	types.write_entity_data(mut w, p.metadata)
	w.write_varuint32(u32(p.entity_links.len))
	for link in p.entity_links {
		link.encode(mut w)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.runtime_entity_id = r.read_varuint64()!
	p.identifier = r.read_string()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector3f.decode(mut r)!
	p.rotation = types_291.Vector2f.decode(mut r)!
	p.head_rotation = r.le_f32()!
	attribute_count := int(r.read_varuint32()!)
	p.attributes = []types_291.AttributeData{cap: attribute_count}
	for _ in 0 .. attribute_count {
		p.attributes << types_291.AttributeData.decode_entity(mut r)!
	}
	p.metadata = types.read_entity_data(mut r)!
	link_count := int(r.read_varuint32()!)
	p.entity_links = []types_291.EntityLinkData{cap: link_count}
	for _ in 0 .. link_count {
		p.entity_links << types_291.EntityLinkData.decode(mut r)!
	}
}
