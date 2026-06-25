module src

import src.serializer
import src.types

pub struct ItemRegistryPacket {
pub mut:
	entries []types.ItemTypeEntry
}

pub fn (p &ItemRegistryPacket) pid() u16 {
	return item_registry_packet
}

pub fn (p &ItemRegistryPacket) name() string {
	return 'ItemRegistryPacket'
}

pub fn (p &ItemRegistryPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ItemRegistryPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.entries = []types.ItemTypeEntry{}
	for _ in 0 .. count {
		string_id := r.read_string()!
		numeric_id := int(r.le_i16()!)
		component_based := r.bool()!
		version := int(r.read_varint32()!)
		component_nbt := r.read_nbt_compound_root()!
		p.entries << types.ItemTypeEntry{
			string_id:       string_id
			numeric_id:      numeric_id
			component_based: component_based
			version:         version
			component_nbt:   component_nbt
		}
	}
}

pub fn (p &ItemRegistryPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_string(entry.string_id)
		w.le_i16(i16(entry.numeric_id))
		w.bool(entry.component_based)
		w.write_varint32(i32(entry.version))
		w.write_nbt_compound_root(entry.component_nbt)
	}
}
