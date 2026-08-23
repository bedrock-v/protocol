module packets

import protocol.serializer

pub struct ResourcePackInfoEntry {
pub mut:
	pack_id       string
	pack_version  string
	pack_size     i64
	content_key   string
	sub_pack_name string
}

pub struct ResourcePacksInfoPacket {
pub mut:
	must_accept           bool
	behavior_pack_entries []ResourcePackInfoEntry
	resource_pack_entries []ResourcePackInfoEntry
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
	w.bool(p.must_accept)
	w.le_i16(i16(p.behavior_pack_entries.len))
	for entry in p.behavior_pack_entries {
		w.write_string(entry.pack_id)
		w.write_string(entry.pack_version)
		w.le_i64(entry.pack_size)
		w.write_string(entry.content_key)
		w.write_string(entry.sub_pack_name)
	}
	w.le_i16(i16(p.resource_pack_entries.len))
	for entry in p.resource_pack_entries {
		w.write_string(entry.pack_id)
		w.write_string(entry.pack_version)
		w.le_i64(entry.pack_size)
		w.write_string(entry.content_key)
		w.write_string(entry.sub_pack_name)
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.bool()!
	behavior_count := int(r.le_i16()!)
	p.behavior_pack_entries = []ResourcePackInfoEntry{cap: serializer.prealloc(behavior_count)}
	for _ in 0 .. behavior_count {
		mut entry := ResourcePackInfoEntry{}
		entry.pack_id = r.read_string()!
		entry.pack_version = r.read_string()!
		entry.pack_size = r.le_i64()!
		entry.content_key = r.read_string()!
		entry.sub_pack_name = r.read_string()!
		p.behavior_pack_entries << entry
	}
	resource_count := int(r.le_i16()!)
	p.resource_pack_entries = []ResourcePackInfoEntry{cap: serializer.prealloc(resource_count)}
	for _ in 0 .. resource_count {
		mut entry := ResourcePackInfoEntry{}
		entry.pack_id = r.read_string()!
		entry.pack_version = r.read_string()!
		entry.pack_size = r.le_i64()!
		entry.content_key = r.read_string()!
		entry.sub_pack_name = r.read_string()!
		p.resource_pack_entries << entry
	}
}
