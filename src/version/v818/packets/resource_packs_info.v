module packets

import serializer
import version.v662.types as types_662

pub struct ResourcePackEntry {
pub mut:
	id                     types_662.Uuid
	version                string
	size                   u64
	content_key            string
	sub_pack_name          string
	content_identity       string
	has_scripts            bool
	is_addon               bool
	is_ray_tracing_capable bool
	cdn_url                string
}

pub fn (e ResourcePackEntry) encode(mut w serializer.Writer) {
	e.id.encode(mut w)
	w.write_string(e.version)
	w.le_u64(e.size)
	w.write_string(e.content_key)
	w.write_string(e.sub_pack_name)
	w.write_string(e.content_identity)
	w.bool(e.has_scripts)
	w.bool(e.is_addon)
	w.bool(e.is_ray_tracing_capable)
	w.write_string(e.cdn_url)
}

pub fn ResourcePackEntry.decode(mut r serializer.Reader) !ResourcePackEntry {
	return ResourcePackEntry{
		id:                     types_662.Uuid.decode(mut r)!
		version:                r.read_string()!
		size:                   r.le_u64()!
		content_key:            r.read_string()!
		sub_pack_name:          r.read_string()!
		content_identity:       r.read_string()!
		has_scripts:            r.bool()!
		is_addon:               r.bool()!
		is_ray_tracing_capable: r.bool()!
		cdn_url:                r.read_string()!
	}
}

pub struct ResourcePacksInfoPacket {
pub mut:
	resource_pack_required        bool
	has_addon_packs               bool
	has_scripts                   bool
	force_disable_vibrant_visuals bool
	world_template_uuid           types_662.Uuid
	world_template_version        string
	resource_packs                []ResourcePackEntry
}

pub fn (p &ResourcePacksInfoPacket) pid() u16 { return 6 }

pub fn (p &ResourcePacksInfoPacket) name() string { return 'ResourcePacksInfoPacket' }

pub fn (p &ResourcePacksInfoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ResourcePacksInfoPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.resource_pack_required)
	w.bool(p.has_addon_packs)
	w.bool(p.has_scripts)
	w.bool(p.force_disable_vibrant_visuals)
	p.world_template_uuid.encode(mut w)
	w.write_string(p.world_template_version)
	w.le_u16(u16(p.resource_packs.len))
	for e in p.resource_packs {
		e.encode(mut w)
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.resource_pack_required = r.bool()!
	p.has_addon_packs = r.bool()!
	p.has_scripts = r.bool()!
	p.force_disable_vibrant_visuals = r.bool()!
	p.world_template_uuid = types_662.Uuid.decode(mut r)!
	p.world_template_version = r.read_string()!
	count := int(r.le_u16()!)
	p.resource_packs = []ResourcePackEntry{cap: count}
	for _ in 0 .. count {
		p.resource_packs << ResourcePackEntry.decode(mut r)!
	}
}
