module packets

import protocol.serializer

pub struct ResourcePackEntry {
pub mut:
	pack_id            string
	pack_version       string
	pack_size          i64
	content_key        string
	sub_pack_name      string
	content_id         string
	scripting          bool
	raytracing_capable bool
}

pub fn (t ResourcePackEntry) encode(mut w serializer.Writer, resource bool) {
	w.write_string(t.pack_id)
	w.write_string(t.pack_version)
	w.le_i64(t.pack_size)
	w.write_string(t.content_key)
	w.write_string(t.sub_pack_name)
	w.write_string(t.content_id)
	w.bool(t.scripting)
	if resource {
		w.bool(t.raytracing_capable)
	}
}

pub fn ResourcePackEntry.decode(mut r serializer.Reader, resource bool) !ResourcePackEntry {
	mut t := ResourcePackEntry{}
	t.pack_id = r.read_string()!
	t.pack_version = r.read_string()!
	t.pack_size = r.le_i64()!
	t.content_key = r.read_string()!
	t.sub_pack_name = r.read_string()!
	t.content_id = r.read_string()!
	t.scripting = r.bool()!
	if resource {
		t.raytracing_capable = r.bool()!
	}
	return t
}

pub struct ResourcePacksInfoPacket {
pub mut:
	forced_to_accept    bool
	scripting_enabled   bool
	behavior_pack_infos []ResourcePackEntry
	resource_pack_infos []ResourcePackEntry
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
	w.le_u16(u16(p.behavior_pack_infos.len))
	for entry in p.behavior_pack_infos {
		entry.encode(mut w, false)
	}
	w.le_u16(u16(p.resource_pack_infos.len))
	for entry in p.resource_pack_infos {
		entry.encode(mut w, true)
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.forced_to_accept = r.bool()!
	p.scripting_enabled = r.bool()!
	behavior_count := int(r.le_u16()!)
	p.behavior_pack_infos = []ResourcePackEntry{cap: behavior_count}
	for _ in 0 .. behavior_count {
		p.behavior_pack_infos << ResourcePackEntry.decode(mut r, false)!
	}
	resource_count := int(r.le_u16()!)
	p.resource_pack_infos = []ResourcePackEntry{cap: resource_count}
	for _ in 0 .. resource_count {
		p.resource_pack_infos << ResourcePackEntry.decode(mut r, true)!
	}
}
