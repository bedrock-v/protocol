module packets

import serializer
import version.v291.types as types_291
import version.v291.enums as enums_291
import version.v407.types as types_407
import version.v431.types as types_431
import version.v534.types as types_534
import version.v557.types as types_557
import version.v560.types

pub struct AddPlayerPacket {
pub mut:
	uuid              types_291.Uuid
	username          string
	runtime_entity_id u64
	platform_chat_id  string
	position          types_291.Vector3f
	motion            types_291.Vector3f
	rotation          types_291.Vector3f
	hand              types_431.ItemData
	game_type         enums_291.GameType
	metadata          []types.DataItem
	properties        types_557.EntityProperties
	abilities         types_534.PlayerAbilitiesData
	entity_links      []types_407.EntityLinkData
	device_id         string
	build_platform    i32
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
	w.write_varuint64(p.runtime_entity_id)
	w.write_string(p.platform_chat_id)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	p.rotation.encode(mut w)
	p.hand.encode(mut w)
	p.game_type.encode(mut w)
	types.write_entity_data(mut w, p.metadata)
	p.properties.encode(mut w)
	p.abilities.encode(mut w)
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
	p.runtime_entity_id = r.read_varuint64()!
	p.platform_chat_id = r.read_string()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector3f.decode(mut r)!
	p.rotation = types_291.Vector3f.decode(mut r)!
	p.hand = types_431.ItemData.decode(mut r)!
	p.game_type = enums_291.GameType.decode(mut r)!
	p.metadata = types.read_entity_data(mut r)!
	p.properties = types_557.EntityProperties.decode(mut r)!
	p.abilities = types_534.PlayerAbilitiesData.decode(mut r)!
	link_count := int(r.read_varuint32()!)
	p.entity_links = []types_407.EntityLinkData{cap: link_count}
	for _ in 0 .. link_count {
		p.entity_links << types_407.EntityLinkData.decode(mut r)!
	}
	p.device_id = r.read_string()!
	p.build_platform = r.le_i32()!
}
