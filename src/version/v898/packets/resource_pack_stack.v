module packets

import serializer
import version.v662.types

pub struct PackEntry {
pub mut:
	id            string
	version       string
	sub_pack_name string
}

pub fn (e PackEntry) encode(mut w serializer.Writer) {
	w.write_string(e.id)
	w.write_string(e.version)
	w.write_string(e.sub_pack_name)
}

pub fn PackEntry.decode(mut r serializer.Reader) !PackEntry {
	return PackEntry{
		id:            r.read_string()!
		version:       r.read_string()!
		sub_pack_name: r.read_string()!
	}
}

pub struct ResourcePackStackPacket {
pub mut:
	texture_pack_required bool
	addon_list            []PackEntry
	base_game_version     types.BaseGameVersion
	experiments           types.Experiments
	include_editor_packs  bool
}

pub fn (p &ResourcePackStackPacket) pid() u16 {
	return 7
}

pub fn (p &ResourcePackStackPacket) name() string {
	return 'ResourcePackStackPacket'
}

pub fn (p &ResourcePackStackPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackStackPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.texture_pack_required)
	w.write_varuint32(u32(p.addon_list.len))
	for e in p.addon_list {
		e.encode(mut w)
	}
	p.base_game_version.encode(mut w)
	p.experiments.encode(mut w)
	w.bool(p.include_editor_packs)
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.texture_pack_required = r.bool()!
	addon_count := int(r.read_varuint32()!)
	p.addon_list = []PackEntry{cap: addon_count}
	for _ in 0 .. addon_count {
		p.addon_list << PackEntry.decode(mut r)!
	}
	p.base_game_version = types.BaseGameVersion.decode(mut r)!
	p.experiments = types.Experiments.decode(mut r)!
	p.include_editor_packs = r.bool()!
}
