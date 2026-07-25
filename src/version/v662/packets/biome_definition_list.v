module packets

import serializer
import nbt

pub struct BiomeDefinitionListPacket {
pub mut:
	biome_definition_data nbt.RootTag
}

pub fn (p &BiomeDefinitionListPacket) pid() u16 { return 122 }

pub fn (p &BiomeDefinitionListPacket) name() string { return 'BiomeDefinitionListPacket' }

pub fn (p &BiomeDefinitionListPacket) can_be_sent_before_login() bool { return false }

pub fn (p &BiomeDefinitionListPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.biome_definition_data)
}

pub fn (mut p BiomeDefinitionListPacket) decode_payload(mut r serializer.Reader) ! {
	p.biome_definition_data = r.read_nbt_compound_root()!
}
