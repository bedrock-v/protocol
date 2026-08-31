module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub enum SubChunkRequestResult as i32 {
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
	copied   = 4
}

pub struct SubChunkPacket {
pub mut:
	dimension          i32
	sub_chunk_position types_291.Vector3i
	data               []u8
	result             SubChunkRequestResult
	height_map_type    HeightMapDataType
	height_map_data    []u8
	cache_enabled      bool
	blob_id            i64
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
	w.write_varint32(p.dimension)
	p.sub_chunk_position.encode(mut w)
	w.write_string_bytes(p.data)
	w.write_varint32(i32(p.result))
	w.u8(u8(p.height_map_type))
	if p.height_map_type == .has_data {
		w.write_raw(p.height_map_data)
	}
	w.bool(p.cache_enabled)
	if p.cache_enabled {
		w.le_i64(p.blob_id)
	}
}

pub fn (mut p SubChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	p.sub_chunk_position = types_291.Vector3i.decode(mut r)!
	p.data = r.read_string_bytes()!
	p.result = unsafe { SubChunkRequestResult(r.read_varint32()!) }
	p.height_map_type = unsafe { HeightMapDataType(r.u8()!) }
	if p.height_map_type == .has_data {
		p.height_map_data = r.read_raw(256)!
	}
	p.cache_enabled = r.bool()!
	if p.cache_enabled {
		p.blob_id = r.le_i64()!
	}
}
