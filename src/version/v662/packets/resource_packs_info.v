module packets

import serializer

pub struct BehaviourPackEntry {
pub mut:
	id               string
	version          string
	size             u64
	content_key      string
	sub_pack_name    string
	content_identity string
	has_scripts      bool
}

pub fn (e BehaviourPackEntry) encode(mut w serializer.Writer) {
	w.write_string(e.id)
	w.write_string(e.version)
	w.le_u64(e.size)
	w.write_string(e.content_key)
	w.write_string(e.sub_pack_name)
	w.write_string(e.content_identity)
	w.bool(e.has_scripts)
}

pub fn BehaviourPackEntry.decode(mut r serializer.Reader) !BehaviourPackEntry {
	return BehaviourPackEntry{
		id:               r.read_string()!
		version:          r.read_string()!
		size:             r.le_u64()!
		content_key:      r.read_string()!
		sub_pack_name:    r.read_string()!
		content_identity: r.read_string()!
		has_scripts:      r.bool()!
	}
}

pub struct ResourcePackEntry {
pub mut:
	id                    string
	version               string
	size                  u64
	content_key           string
	sub_pack_name         string
	content_identity      string
	has_scripts           bool
	is_ray_tracing_capable bool
}

pub fn (e ResourcePackEntry) encode(mut w serializer.Writer) {
	w.write_string(e.id)
	w.write_string(e.version)
	w.le_u64(e.size)
	w.write_string(e.content_key)
	w.write_string(e.sub_pack_name)
	w.write_string(e.content_identity)
	w.bool(e.has_scripts)
	w.bool(e.is_ray_tracing_capable)
}

pub fn ResourcePackEntry.decode(mut r serializer.Reader) !ResourcePackEntry {
	return ResourcePackEntry{
		id:                     r.read_string()!
		version:                r.read_string()!
		size:                   r.le_u64()!
		content_key:            r.read_string()!
		sub_pack_name:          r.read_string()!
		content_identity:       r.read_string()!
		has_scripts:            r.bool()!
		is_ray_tracing_capable: r.bool()!
	}
}

pub struct CDNUrl {
pub mut:
	first  string
	second string
}

pub fn (e CDNUrl) encode(mut w serializer.Writer) {
	w.write_string(e.first)
	w.write_string(e.second)
}

pub fn CDNUrl.decode(mut r serializer.Reader) !CDNUrl {
	return CDNUrl{
		first:  r.read_string()!
		second: r.read_string()!
	}
}

pub struct ResourcePacksInfoPacket {
pub mut:
	resource_pack_required     bool
	has_addon_packs            bool
	has_scripts                bool
	force_server_packs_enabled bool
	behaviour_packs            []BehaviourPackEntry
	resource_packs             []ResourcePackEntry
	cdn_urls                   []CDNUrl
}

pub fn (p &ResourcePacksInfoPacket) pid() u16 { return 6 }

pub fn (p &ResourcePacksInfoPacket) name() string { return 'ResourcePacksInfoPacket' }

pub fn (p &ResourcePacksInfoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ResourcePacksInfoPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.resource_pack_required)
	w.bool(p.has_addon_packs)
	w.bool(p.has_scripts)
	w.bool(p.force_server_packs_enabled)
	w.le_u16(u16(p.behaviour_packs.len))
	for e in p.behaviour_packs {
		e.encode(mut w)
	}
	w.le_u16(u16(p.resource_packs.len))
	for e in p.resource_packs {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.cdn_urls.len))
	for e in p.cdn_urls {
		e.encode(mut w)
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.resource_pack_required = r.bool()!
	p.has_addon_packs = r.bool()!
	p.has_scripts = r.bool()!
	p.force_server_packs_enabled = r.bool()!
	beh_count := int(r.le_u16()!)
	p.behaviour_packs = []BehaviourPackEntry{cap: beh_count}
	for _ in 0 .. beh_count {
		p.behaviour_packs << BehaviourPackEntry.decode(mut r)!
	}
	res_count := int(r.le_u16()!)
	p.resource_packs = []ResourcePackEntry{cap: res_count}
	for _ in 0 .. res_count {
		p.resource_packs << ResourcePackEntry.decode(mut r)!
	}
	cdn_count := int(r.read_varuint32()!)
	p.cdn_urls = []CDNUrl{cap: cdn_count}
	for _ in 0 .. cdn_count {
		p.cdn_urls << CDNUrl.decode(mut r)!
	}
}
