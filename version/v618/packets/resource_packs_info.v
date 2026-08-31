module packets

import protocol.serializer

pub struct ResourcePacksInfoEntry {
pub mut:
	pack_id            string
	pack_version       string
	pack_size          i64
	content_key        string
	sub_pack_name      string
	content_id         string
	scripting          bool
	raytracing_capable bool
	cdn_url            string
}

pub fn (e ResourcePacksInfoEntry) encode(mut w serializer.Writer, resource bool) {
	w.write_string(e.pack_id)
	w.write_string(e.pack_version)
	w.le_i64(e.pack_size)
	w.write_string(e.content_key)
	w.write_string(e.sub_pack_name)
	w.write_string(e.content_id)
	w.bool(e.scripting)
	if resource {
		w.bool(e.raytracing_capable)
	}
}

pub fn ResourcePacksInfoEntry.decode(mut r serializer.Reader, resource bool) !ResourcePacksInfoEntry {
	mut e := ResourcePacksInfoEntry{
		pack_id:       r.read_string()!
		pack_version:  r.read_string()!
		pack_size:     r.le_i64()!
		content_key:   r.read_string()!
		sub_pack_name: r.read_string()!
		content_id:    r.read_string()!
		scripting:     r.bool()!
	}
	if resource {
		e.raytracing_capable = r.bool()!
	}
	return e
}

pub struct ResourcePacksInfoPacket {
pub mut:
	forced_to_accept             bool
	scripting_enabled            bool
	forcing_server_packs_enabled bool
	behavior_pack_infos          []ResourcePacksInfoEntry
	resource_pack_infos          []ResourcePacksInfoEntry
}

pub fn (p &ResourcePacksInfoPacket) pid() u16 {
	return 6
}

pub fn (p &ResourcePacksInfoPacket) name() string {
	return 'ResourcePacksInfoPacket'
}

pub fn (p &ResourcePacksInfoPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePacksInfoPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.forced_to_accept)
	w.bool(p.scripting_enabled)
	w.bool(p.forcing_server_packs_enabled)
	w.le_u16(u16(p.behavior_pack_infos.len))
	for e in p.behavior_pack_infos {
		e.encode(mut w, false)
	}
	w.le_u16(u16(p.resource_pack_infos.len))
	for e in p.resource_pack_infos {
		e.encode(mut w, true)
	}
	mut cdn_count := u32(0)
	for e in p.resource_pack_infos {
		if e.cdn_url.len > 0 {
			cdn_count++
		}
	}
	w.write_varuint32(cdn_count)
	for e in p.resource_pack_infos {
		if e.cdn_url.len > 0 {
			w.write_string('${e.pack_id}_${e.pack_version}')
			w.write_string(e.cdn_url)
		}
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.forced_to_accept = r.bool()!
	p.scripting_enabled = r.bool()!
	p.forcing_server_packs_enabled = r.bool()!
	behavior_count := int(r.le_u16()!)
	p.behavior_pack_infos = []ResourcePacksInfoEntry{cap: serializer.prealloc(behavior_count)}
	for _ in 0 .. behavior_count {
		p.behavior_pack_infos << ResourcePacksInfoEntry.decode(mut r, false)!
	}
	resource_count := int(r.le_u16()!)
	p.resource_pack_infos = []ResourcePacksInfoEntry{cap: serializer.prealloc(resource_count)}
	for _ in 0 .. resource_count {
		p.resource_pack_infos << ResourcePacksInfoEntry.decode(mut r, true)!
	}
	cdn_count := r.read_count()!
	mut cdn_keys := []string{cap: serializer.prealloc(cdn_count)}
	mut cdn_urls := []string{cap: serializer.prealloc(cdn_count)}
	for _ in 0 .. cdn_count {
		cdn_keys << r.read_string()!
		cdn_urls << r.read_string()!
	}
	for mut e in p.resource_pack_infos {
		key := '${e.pack_id}_${e.pack_version}'
		for i, k in cdn_keys {
			if k == key {
				e.cdn_url = cdn_urls[i]
				break
			}
		}
	}
}
