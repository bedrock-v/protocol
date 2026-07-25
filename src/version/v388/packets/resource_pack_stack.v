module packets

import serializer
import version.v291.packets as packets_291

pub struct ResourcePackStackPacket {
pub mut:
	forced_to_accept  bool
	behavior_packs    []packets_291.ResourcePackStackEntry
	resource_packs    []packets_291.ResourcePackStackEntry
	legacy_experiment bool
	game_version      string
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
	w.bool(p.legacy_experiment)
	w.write_string(p.game_version)
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.forced_to_accept = r.bool()!
	behavior_count := int(r.read_varuint32()!)
	p.behavior_packs = []packets_291.ResourcePackStackEntry{cap: behavior_count}
	for _ in 0 .. behavior_count {
		p.behavior_packs << packets_291.ResourcePackStackEntry.decode(mut r)!
	}
	resource_count := int(r.read_varuint32()!)
	p.resource_packs = []packets_291.ResourcePackStackEntry{cap: resource_count}
	for _ in 0 .. resource_count {
		p.resource_packs << packets_291.ResourcePackStackEntry.decode(mut r)!
	}
	p.legacy_experiment = r.bool()!
	p.game_version = r.read_string()!
}
