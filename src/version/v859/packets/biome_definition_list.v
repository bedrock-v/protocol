module packets

import protocol.serializer
import protocol.version.v859.types

pub struct BiomeEntry {
pub mut:
	name_index u16
	definition types.BiomeDefinition
}

pub fn (t BiomeEntry) encode(mut w serializer.Writer) {
	w.le_u16(t.name_index)
	t.definition.encode(mut w)
}

pub fn BiomeEntry.decode(mut r serializer.Reader) !BiomeEntry {
	return BiomeEntry{
		name_index: r.le_u16()!
		definition: types.BiomeDefinition.decode(mut r)!
	}
}

pub struct BiomeDefinitionListPacket {
pub mut:
	biomes  []BiomeEntry
	strings []string
}

pub fn (p &BiomeDefinitionListPacket) pid() u16 {
	return 122
}

pub fn (p &BiomeDefinitionListPacket) name() string {
	return 'BiomeDefinitionListPacket'
}

pub fn (p &BiomeDefinitionListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BiomeDefinitionListPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.biomes.len))
	for e in p.biomes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.strings.len))
	for s in p.strings {
		w.write_string(s)
	}
}

pub fn (mut p BiomeDefinitionListPacket) decode_payload(mut r serializer.Reader) ! {
	biome_count := int(r.read_varuint32()!)
	mut biomes := []BiomeEntry{cap: biome_count}
	for _ in 0 .. biome_count {
		biomes << BiomeEntry.decode(mut r)!
	}
	p.biomes = biomes
	string_count := int(r.read_varuint32()!)
	mut strings := []string{cap: string_count}
	for _ in 0 .. string_count {
		strings << r.read_string()!
	}
	p.strings = strings
}
