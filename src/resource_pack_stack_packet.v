module src

import src.serializer
import src.types

pub struct ResourcePackStackEntry {
pub mut:
	pack_id       string
	version       string
	sub_pack_name string
}

pub struct ResourcePackStackPacket {
pub mut:
	must_accept            bool
	resource_pack_stack    []ResourcePackStackEntry
	base_game_version      string
	experiments            types.Experiments
	use_vanilla_editor_packs bool
}

pub fn (p &ResourcePackStackPacket) pid() u16 {
	return resource_pack_stack_packet
}

pub fn (p &ResourcePackStackPacket) name() string {
	return 'ResourcePackStackPacket'
}

pub fn (p &ResourcePackStackPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.bool()!
	count := r.read_varuint32()!
	p.resource_pack_stack = []ResourcePackStackEntry{}
	for _ in 0 .. count {
		p.resource_pack_stack << ResourcePackStackEntry{
			pack_id:       r.read_string()!
			version:       r.read_string()!
			sub_pack_name: r.read_string()!
		}
	}
	p.base_game_version = r.read_string()!
	p.experiments = r.read_experiments()!
	p.use_vanilla_editor_packs = r.bool()!
}

pub fn (p &ResourcePackStackPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.must_accept)
	w.write_varuint32(u32(p.resource_pack_stack.len))
	for e in p.resource_pack_stack {
		w.write_string(e.pack_id)
		w.write_string(e.version)
		w.write_string(e.sub_pack_name)
	}
	w.write_string(p.base_game_version)
	w.write_experiments(p.experiments)
	w.bool(p.use_vanilla_editor_packs)
}
