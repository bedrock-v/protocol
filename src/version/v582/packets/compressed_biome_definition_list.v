module packets

import nbt
import protocol.serializer

const compressed_indicator = [u8(0x43), 0x4f, 0x4d, 0x50, 0x52, 0x45, 0x53, 0x53, 0x45, 0x44]

pub struct CompressedBiomeDefinitionListPacket {
pub mut:
	definitions nbt.RootTag
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
	serialized := nbt.encode(nbt.RootTag{
		name: ''
		tag:  p.definitions.tag
	})
	mut compressed := serializer.new_writer()
	compressed.write_raw(compressed_indicator)
	compressed.le_u16(0)
	for b in serialized {
		compressed.u8(b)
		if b == 0xff {
			compressed.le_u16(1)
		}
	}
	blob := compressed.bytes()
	w.write_varuint32(u32(blob.len))
	w.write_raw(blob)
}

pub fn (mut p CompressedBiomeDefinitionListPacket) decode_payload(mut r serializer.Reader) ! {
	length := r.read_count()!
	blob := r.read_raw(length)!
	mut br := serializer.new_reader(blob)
	br.read_raw(compressed_indicator.len)!
	dictionary_size := int(br.le_u16()!)
	mut dictionary := [][]u8{cap: serializer.prealloc(dictionary_size)}
	for _ in 0 .. dictionary_size {
		entry_len := int(br.u8()!)
		dictionary << br.read_raw(entry_len)!
	}
	mut decompressed := []u8{}
	for br.remaining() > 0 {
		key := br.u8()!
		if key != 0xff {
			decompressed << key
			continue
		}
		index := int(br.le_u16()!)
		if index >= 0 && index < dictionary.len {
			decompressed << dictionary[index]
		} else {
			decompressed << key
		}
	}
	res := nbt.decode(decompressed)!
	p.definitions = res.root
}
