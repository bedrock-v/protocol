module packets

import protocol.serializer
import protocol.version.v662.types

pub const level_chunk_limited = u32(0xfffffffe)

pub struct LevelChunkPacket {
pub mut:
	chunk_position        types.ChunkPos
	dimension_id          i32
	sub_chunk_count       u32
	sub_chunk_limit       u16
	cache_enabled         bool
	cache_blobs           []u64
	serialized_chunk_data []u8
}

pub fn (p &LevelChunkPacket) pid() u16 {
	return 58
}

pub fn (p &LevelChunkPacket) name() string {
	return 'LevelChunkPacket'
}

pub fn (p &LevelChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelChunkPacket) encode_payload(mut w serializer.Writer) {
	p.chunk_position.encode(mut w)
	w.write_varint32(p.dimension_id)
	w.write_varuint32(p.sub_chunk_count)
	if p.sub_chunk_count == level_chunk_limited {
		w.le_u16(p.sub_chunk_limit)
	}
	w.bool(p.cache_enabled)
	if p.cache_enabled {
		w.write_varuint32(u32(p.cache_blobs.len))
		for b in p.cache_blobs {
			w.le_u64(b)
		}
	}
	w.write_string_bytes(p.serialized_chunk_data)
}

pub fn (mut p LevelChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_position = types.ChunkPos.decode(mut r)!
	p.dimension_id = r.read_varint32()!
	p.sub_chunk_count = r.read_varuint32()!
	if p.sub_chunk_count == level_chunk_limited {
		p.sub_chunk_limit = r.le_u16()!
	}
	p.cache_enabled = r.bool()!
	if p.cache_enabled {
		count := int(r.read_varuint32()!)
		p.cache_blobs = []u64{cap: count}
		for _ in 0 .. count {
			p.cache_blobs << r.le_u64()!
		}
	}
	p.serialized_chunk_data = r.read_string_bytes()!
}
