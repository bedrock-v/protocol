module packets

import protocol.serializer

pub struct CompressedBiomeDefinitionListPacket {
pub mut:
	compressed_biome_data string
}

pub fn (p &CompressedBiomeDefinitionListPacket) pid() u16 {
	return 301
}

pub fn (p &CompressedBiomeDefinitionListPacket) name() string {
	return 'CompressedBiomeDefinitionListPacket'
}

pub fn (p &CompressedBiomeDefinitionListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CompressedBiomeDefinitionListPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.compressed_biome_data)
}

pub fn (mut p CompressedBiomeDefinitionListPacket) decode_payload(mut r serializer.Reader) ! {
	p.compressed_biome_data = r.read_string()!
}
