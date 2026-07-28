module packets

import protocol.serializer

pub struct ResourcePackStackEntry {
pub mut:
	pack_id       string
	pack_version  string
	sub_pack_name string
}

pub fn (e ResourcePackStackEntry) encode(mut w serializer.Writer) {
	w.write_string(e.pack_id)
	w.write_string(e.pack_version)
	w.write_string(e.sub_pack_name)
}

pub fn ResourcePackStackEntry.decode(mut r serializer.Reader) !ResourcePackStackEntry {
	return ResourcePackStackEntry{
		pack_id:       r.read_string()!
		pack_version:  r.read_string()!
		sub_pack_name: r.read_string()!
	}
}

pub struct ResourcePackStackPacket {
pub mut:
	forced_to_accept bool
	behavior_packs   []ResourcePackStackEntry
	resource_packs   []ResourcePackStackEntry
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
	w.bool(p.forced_to_accept)
	w.write_varuint32(u32(p.behavior_packs.len))
	for e in p.behavior_packs {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.resource_packs.len))
	for e in p.resource_packs {
		e.encode(mut w)
	}
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.forced_to_accept = r.bool()!
	behavior_count := int(r.read_varuint32()!)
	p.behavior_packs = []ResourcePackStackEntry{cap: behavior_count}
	for _ in 0 .. behavior_count {
		p.behavior_packs << ResourcePackStackEntry.decode(mut r)!
	}
	resource_count := int(r.read_varuint32()!)
	p.resource_packs = []ResourcePackStackEntry{cap: resource_count}
	for _ in 0 .. resource_count {
		p.resource_packs << ResourcePackStackEntry.decode(mut r)!
	}
}
