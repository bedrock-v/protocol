module packets

import serializer
import version.v291.types as types_291

pub const height_map_length = 256

pub enum SubChunkRequestResult as u8 {
	undefined           = 0
	success             = 1
	chunk_not_found     = 2
	invalid_dimension   = 3
	player_not_found    = 4
	index_out_of_bounds = 5
	success_all_air     = 6
}

pub enum HeightMapDataType as u8 {
	no_data  = 0
	has_data = 1
	too_high = 2
	too_low  = 3
}

pub struct SubChunkData {
pub mut:
	offset          [3]i8
	result          SubChunkRequestResult
	data            []u8
	height_map_type HeightMapDataType
	height_map_data []u8
	blob_id         i64
}

pub struct SubChunkPacket {
pub mut:
	cache_enabled   bool
	dimension       i32
	center_position types_291.Vector3i
	sub_chunks      []SubChunkData
}

pub fn (p &SubChunkPacket) pid() u16 {
	return 174
}

pub fn (p &SubChunkPacket) name() string {
	return 'SubChunkPacket'
}

pub fn (p &SubChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SubChunkPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.cache_enabled)
	w.write_varint32(p.dimension)
	p.center_position.encode(mut w)
	w.le_i32(i32(p.sub_chunks.len))
	for sub_chunk in p.sub_chunks {
		w.i8(sub_chunk.offset[0])
		w.i8(sub_chunk.offset[1])
		w.i8(sub_chunk.offset[2])
		w.u8(u8(sub_chunk.result))
		if sub_chunk.result != .success_all_air || !p.cache_enabled {
			w.write_string_bytes(sub_chunk.data)
		}
		w.u8(u8(sub_chunk.height_map_type))
		if sub_chunk.height_map_type == .has_data {
			w.write_raw(sub_chunk.height_map_data)
		}
		if p.cache_enabled {
			w.le_i64(sub_chunk.blob_id)
		}
	}
}

pub fn (mut p SubChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.cache_enabled = r.bool()!
	p.dimension = r.read_varint32()!
	p.center_position = types_291.Vector3i.decode(mut r)!
	sub_chunk_count := int(r.le_i32()!)
	p.sub_chunks = []SubChunkData{cap: sub_chunk_count}
	for _ in 0 .. sub_chunk_count {
		mut sub_chunk := SubChunkData{}
		sub_chunk.offset = [r.i8()!, r.i8()!, r.i8()!]!
		sub_chunk.result = unsafe { SubChunkRequestResult(r.u8()!) }
		if sub_chunk.result != .success_all_air || !p.cache_enabled {
			sub_chunk.data = r.read_string_bytes()!
		}
		sub_chunk.height_map_type = unsafe { HeightMapDataType(r.u8()!) }
		if sub_chunk.height_map_type == .has_data {
			sub_chunk.height_map_data = r.read_raw(height_map_length)!
		}
		if p.cache_enabled {
			sub_chunk.blob_id = r.le_i64()!
		}
		p.sub_chunks << sub_chunk
	}
}
