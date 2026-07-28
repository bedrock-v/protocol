module packets

import protocol.serializer
import protocol.version.v662.types

pub enum SubChunkRequestResult as i8 {
	undefined                = 0
	success                  = 1
	level_chunk_doesnt_exist = 2
	wrong_dimension          = 3
	player_doesnt_exist      = 4
	index_out_of_bounds      = 5
	success_all_air          = 6
}

pub enum HeightMapDataType as i8 {
	no_data      = 0
	has_data     = 1
	all_too_high = 2
	all_too_low  = 3
}

pub struct SubChunkDataEntry {
pub mut:
	sub_chunk_pos_offset     types.SubChunkPosOffset
	sub_chunk_request_result SubChunkRequestResult
	serialized_sub_chunk     []u8
	height_map_data_type     HeightMapDataType
	height_map_data          [16][16]i8
	blob_id                  u64
}

pub struct SubChunkPacket {
pub mut:
	cache_enabled  bool
	dimension_type i32
	center_pos     types.SubChunkPos
	sub_chunk_data []SubChunkDataEntry
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
	w.write_varint32(p.dimension_type)
	p.center_pos.encode(mut w)
	w.le_u32(u32(p.sub_chunk_data.len))
	for e in p.sub_chunk_data {
		e.sub_chunk_pos_offset.encode(mut w)
		w.i8(i8(e.sub_chunk_request_result))
		if e.sub_chunk_request_result != .success_all_air || !p.cache_enabled {
			w.write_string_bytes(e.serialized_sub_chunk)
		}
		w.i8(i8(e.height_map_data_type))
		if e.height_map_data_type == .has_data {
			for x in 0 .. 16 {
				for y in 0 .. 16 {
					w.i8(e.height_map_data[x][y])
				}
			}
		}
		if p.cache_enabled {
			w.le_u64(e.blob_id)
		}
	}
}

pub fn (mut p SubChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.cache_enabled = r.bool()!
	p.dimension_type = r.read_varint32()!
	p.center_pos = types.SubChunkPos.decode(mut r)!
	count := int(r.le_u32()!)
	p.sub_chunk_data = []SubChunkDataEntry{cap: count}
	for _ in 0 .. count {
		mut e := SubChunkDataEntry{}
		e.sub_chunk_pos_offset = types.SubChunkPosOffset.decode(mut r)!
		e.sub_chunk_request_result = unsafe { SubChunkRequestResult(r.i8()!) }
		if e.sub_chunk_request_result != .success_all_air || !p.cache_enabled {
			e.serialized_sub_chunk = r.read_string_bytes()!
		}
		e.height_map_data_type = unsafe { HeightMapDataType(r.i8()!) }
		if e.height_map_data_type == .has_data {
			for x in 0 .. 16 {
				for y in 0 .. 16 {
					e.height_map_data[x][y] = r.i8()!
				}
			}
		}
		if p.cache_enabled {
			e.blob_id = r.le_u64()!
		}
		p.sub_chunk_data << e
	}
}
