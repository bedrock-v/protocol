module src

import src.serializer
import src.types

pub struct ResourcePackInfoEntry {
pub mut:
	uuid           types.UUID
	version        string
	size_bytes     u64
	encryption_key string
	sub_pack_name  string
	content_id     string
	has_scripts    bool
	is_addon_pack  bool
	rtx_capable    bool
	cdn_url        string
}

pub struct ResourcePacksInfoPacket {
pub mut:
	must_accept                 bool
	has_addons                  bool
	has_scripts                 bool
	force_disable_vibrant_visuals bool
	world_template_id           types.UUID
	world_template_version      string
	entries                     []ResourcePackInfoEntry
}

pub fn (p &ResourcePacksInfoPacket) pid() u16 {
	return resource_packs_info_packet
}

pub fn (p &ResourcePacksInfoPacket) name() string {
	return 'ResourcePacksInfoPacket'
}

pub fn (p &ResourcePacksInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.bool()!
	p.has_addons = r.bool()!
	p.has_scripts = r.bool()!
	p.force_disable_vibrant_visuals = r.bool()!
	p.world_template_id = r.read_uuid()!
	p.world_template_version = r.read_string()!
	count := r.le_u16()!
	p.entries = []ResourcePackInfoEntry{}
	for _ in 0 .. count {
		p.entries << ResourcePackInfoEntry{
			uuid:           r.read_uuid()!
			version:        r.read_string()!
			size_bytes:     r.le_u64()!
			encryption_key: r.read_string()!
			sub_pack_name:  r.read_string()!
			content_id:     r.read_string()!
			has_scripts:    r.bool()!
			is_addon_pack:  r.bool()!
			rtx_capable:    r.bool()!
			cdn_url:        r.read_string()!
		}
	}
}

pub fn (p &ResourcePacksInfoPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.must_accept)
	w.bool(p.has_addons)
	w.bool(p.has_scripts)
	w.bool(p.force_disable_vibrant_visuals)
	w.write_uuid(p.world_template_id)
	w.write_string(p.world_template_version)
	w.le_u16(u16(p.entries.len))
	for e in p.entries {
		w.write_uuid(e.uuid)
		w.write_string(e.version)
		w.le_u64(e.size_bytes)
		w.write_string(e.encryption_key)
		w.write_string(e.sub_pack_name)
		w.write_string(e.content_id)
		w.bool(e.has_scripts)
		w.bool(e.is_addon_pack)
		w.bool(e.rtx_capable)
		w.write_string(e.cdn_url)
	}
}
