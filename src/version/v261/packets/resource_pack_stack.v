module packets

import serializer

pub struct ResourcePackStackEntry {
pub mut:
	pack_id      string
	pack_version string
	extra        string
}

pub struct ResourcePackStackPacket {
pub mut:
	must_accept         bool
	behavior_pack_stack []ResourcePackStackEntry
	resource_pack_stack []ResourcePackStackEntry
}

pub fn (p &ResourcePackStackPacket) pid() u16 {
	return 7
}

pub fn (p &ResourcePackStackPacket) name() string {
	return 'ResourcePackStackPacket'
}

pub fn (p &ResourcePackStackPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackStackPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.must_accept)
	w.write_varuint32(u32(p.behavior_pack_stack.len))
	for entry in p.behavior_pack_stack {
		w.write_string(entry.pack_id)
		w.write_string(entry.pack_version)
		w.write_string(entry.extra)
	}
	w.write_varuint32(u32(p.resource_pack_stack.len))
	for entry in p.resource_pack_stack {
		w.write_string(entry.pack_id)
		w.write_string(entry.pack_version)
		w.write_string(entry.extra)
	}
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.bool()!
	behavior_count := int(r.read_varuint32()!)
	p.behavior_pack_stack = []ResourcePackStackEntry{cap: behavior_count}
	for _ in 0 .. behavior_count {
		mut entry := ResourcePackStackEntry{}
		entry.pack_id = r.read_string()!
		entry.pack_version = r.read_string()!
		entry.extra = r.read_string()!
		p.behavior_pack_stack << entry
	}
	resource_count := int(r.read_varuint32()!)
	p.resource_pack_stack = []ResourcePackStackEntry{cap: resource_count}
	for _ in 0 .. resource_count {
		mut entry := ResourcePackStackEntry{}
		entry.pack_id = r.read_string()!
		entry.pack_version = r.read_string()!
		entry.extra = r.read_string()!
		p.resource_pack_stack << entry
	}
}
