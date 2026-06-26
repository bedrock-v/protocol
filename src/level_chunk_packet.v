module src

import src.serializer
import src.types

pub const level_chunk_request_explicit = u8(0)
pub const level_chunk_request_full = u8(1)
pub const level_chunk_request_truncated = u8(2)

const level_chunk_full_fake_count = u32(0xffffffff)
const level_chunk_truncated_fake_count = u32(0xfffffffe)

pub struct LevelChunkPacket {
pub mut:
	chunk_position   types.ChunkPosition
	dimension_id     int
	request_type     u8
	sub_chunk_count  u32
	cache_enabled    bool
	used_blob_hashes []u64
	extra_payload    string
}

pub fn (p &LevelChunkPacket) pid() u16 {
	return level_chunk_packet
}

pub fn (p &LevelChunkPacket) name() string {
	return 'LevelChunkPacket'
}

pub fn (p &LevelChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LevelChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_position = r.read_chunk_position()!
	p.dimension_id = r.read_varint32()!
	count := r.read_varuint32()!
	if count == level_chunk_full_fake_count {
		p.request_type = level_chunk_request_full
		p.sub_chunk_count = 0
	} else if count == level_chunk_truncated_fake_count {
		p.request_type = level_chunk_request_truncated
		p.sub_chunk_count = u32(r.le_u16()!)
	} else {
		p.request_type = level_chunk_request_explicit
		p.sub_chunk_count = count
	}
	p.cache_enabled = r.bool()!
	p.used_blob_hashes = []u64{}
	if p.cache_enabled {
		hash_count := r.read_varuint32()!
		for _ in 0 .. hash_count {
			p.used_blob_hashes << r.le_u64()!
		}
	}
	p.extra_payload = r.read_string()!
}

pub fn (p &LevelChunkPacket) encode_payload(mut w serializer.Writer) {
	w.write_chunk_position(p.chunk_position)
	w.write_varint32(p.dimension_id)
	if p.request_type == level_chunk_request_full {
		w.write_varuint32(level_chunk_full_fake_count)
	} else if p.request_type == level_chunk_request_truncated {
		w.write_varuint32(level_chunk_truncated_fake_count)
		w.le_u16(u16(p.sub_chunk_count))
	} else {
		w.write_varuint32(p.sub_chunk_count)
	}
	w.bool(p.cache_enabled)
	if p.cache_enabled {
		w.write_varuint32(u32(p.used_blob_hashes.len))
		for hash in p.used_blob_hashes {
			w.le_u64(hash)
		}
	}
	w.write_string(p.extra_payload)
}
