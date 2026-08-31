module packets

import protocol.serializer
import protocol.version.v137.types

pub struct AddPlayerPacket {
pub mut:
	uuid              types.Uuid
	username          string
	entity_unique_id  i64
	entity_runtime_id u64
	position          types.Vector3f
	motion            types.Vector3f
	pitch             f32
	head_yaw          f32
	yaw               f32
	item              types.ItemData
	metadata          []types.DataItem
	uvarint1          u32
	uvarint2          u32
	uvarint3          u32
	uvarint4          u32
	uvarint5          u32
	long1             i64
	entity_links      []types.EntityLink
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
	w.write_string(p.username)
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	w.le_f32(p.pitch)
	w.le_f32(p.head_yaw)
	w.le_f32(p.yaw)
	p.item.encode(mut w)
	types.write_entity_data(mut w, p.metadata)
	w.write_varuint32(p.uvarint1)
	w.write_varuint32(p.uvarint2)
	w.write_varuint32(p.uvarint3)
	w.write_varuint32(p.uvarint4)
	w.write_varuint32(p.uvarint5)
	w.le_i64(p.long1)
	w.write_varuint32(u32(p.entity_links.len))
	for link in p.entity_links {
		link.encode(mut w)
	}
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.Uuid.decode(mut r)!
	p.username = r.read_string()!
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.position = types.Vector3f.decode(mut r)!
	p.motion = types.Vector3f.decode(mut r)!
	p.pitch = r.le_f32()!
	p.head_yaw = r.le_f32()!
	p.yaw = r.le_f32()!
	p.item = types.ItemData.decode(mut r)!
	p.metadata = types.read_entity_data(mut r)!
	p.uvarint1 = r.read_varuint32()!
	p.uvarint2 = r.read_varuint32()!
	p.uvarint3 = r.read_varuint32()!
	p.uvarint4 = r.read_varuint32()!
	p.uvarint5 = r.read_varuint32()!
	p.long1 = r.le_i64()!
	link_count := r.read_count()!
	p.entity_links = []types.EntityLink{cap: serializer.prealloc(link_count)}
	for _ in 0 .. link_count {
		p.entity_links << types.EntityLink.decode(mut r)!
	}
}
