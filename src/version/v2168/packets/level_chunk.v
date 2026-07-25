module packets

import serializer
import version.v662.types as types_662

pub struct LevelChunkPacket {
pub mut:
	chunk_position                 types_662.ChunkPos
	dimension_id                   i32
	sub_chunk_count                u32
	client_request_sub_chunk_limit ?i32
	cache_enabled                  bool
	cache_blobs                    []u64
	serialized_chunk_data          []u8
}

pub fn (p &LevelChunkPacket) pid() u16 { return 58 }

pub fn (p &LevelChunkPacket) name() string { return 'LevelChunkPacket' }

pub fn (p &LevelChunkPacket) can_be_sent_before_login() bool { return false }

pub fn (p &LevelChunkPacket) encode_payload(mut w serializer.Writer) {
	p.chunk_position.encode(mut w)
	w.write_varint32(p.dimension_id)
	w.write_varuint32(p.sub_chunk_count)
	if v := p.client_request_sub_chunk_limit {
		w.bool(true)
		w.write_varint32(v)
	} else {
		w.bool(false)
	}
	w.bool(p.cache_enabled)
	w.write_varuint32(u32(p.cache_blobs.len))
	for b in p.cache_blobs {
		w.le_u64(b)
	}
	w.write_string_bytes(p.serialized_chunk_data)
}

pub fn (mut p LevelChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_position = types_662.ChunkPos.decode(mut r)!
	p.dimension_id = r.read_varint32()!
	p.sub_chunk_count = r.read_varuint32()!
	if r.bool()! {
		p.client_request_sub_chunk_limit = r.read_varint32()!
	}
	p.cache_enabled = r.bool()!
	{
		count := int(r.read_varuint32()!)
		p.cache_blobs = []u64{cap: count}
		for _ in 0 .. count {
			p.cache_blobs << r.le_u64()!
		}
	}
	p.serialized_chunk_data = r.read_string_bytes()!
}
