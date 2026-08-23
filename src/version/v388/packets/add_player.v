module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v340.types as types_340
import protocol.version.v388.types

pub struct AddPlayerPacket {
pub mut:
	uuid               types_291.Uuid
	username           string
	unique_entity_id   i64
	runtime_entity_id  u64
	platform_chat_id   string
	position           types_291.Vector3f
	motion             types_291.Vector3f
	rotation           types_291.Vector3f
	hand               types_340.ItemData
	metadata           []types.DataItem
	adventure_settings types_291.AdventureSettingsData
	entity_links       []types_291.EntityLinkData
	device_id          string
	build_platform     i32
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
	w.write_varint64(p.unique_entity_id)
	w.write_varuint64(p.runtime_entity_id)
	w.write_string(p.platform_chat_id)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	p.rotation.encode(mut w)
	p.hand.encode(mut w)
	types.write_entity_data(mut w, p.metadata)
	p.adventure_settings.encode(mut w)
	w.write_varuint32(u32(p.entity_links.len))
	for link in p.entity_links {
		link.encode(mut w)
	}
	w.write_string(p.device_id)
	w.le_i32(p.build_platform)
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types_291.Uuid.decode(mut r)!
	p.username = r.read_string()!
	p.unique_entity_id = r.read_varint64()!
	p.runtime_entity_id = r.read_varuint64()!
	p.platform_chat_id = r.read_string()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector3f.decode(mut r)!
	p.rotation = types_291.Vector3f.decode(mut r)!
	p.hand = types_340.ItemData.decode(mut r)!
	p.metadata = types.read_entity_data(mut r)!
	p.adventure_settings = types_291.AdventureSettingsData.decode(mut r)!
	link_count := r.read_count()!
	p.entity_links = []types_291.EntityLinkData{cap: serializer.prealloc(link_count)}
	for _ in 0 .. link_count {
		p.entity_links << types_291.EntityLinkData.decode(mut r)!
	}
	p.device_id = r.read_string()!
	p.build_platform = r.le_i32()!
}
