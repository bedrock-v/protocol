module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v662.types as types_662

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
	sub_chunk_pos_offset        types_662.SubChunkPosOffset
	sub_chunk_request_result    SubChunkRequestResult
	serialized_sub_chunk        ?[]u8
	height_map_data_type        HeightMapDataType
	height_map_data             [16][16]i8
	render_height_map_data_type HeightMapDataType
	render_height_map_data      [16][16]i8
	blob_id                     ?u64
}

pub fn (e SubChunkDataEntry) encode(mut w serializer.Writer) {
	e.sub_chunk_pos_offset.encode(mut w)
	w.i8(i8(e.sub_chunk_request_result))
	if data := e.serialized_sub_chunk {
		w.bool(true)
		w.write_string_bytes(data)
	} else {
		w.bool(false)
	}
	w.i8(i8(e.height_map_data_type))
	encode_opt_height_map(mut w, e.height_map_data_type == .has_data, e.height_map_data)
	w.i8(i8(e.render_height_map_data_type))
	encode_opt_height_map(mut w, e.render_height_map_data_type == .has_data, e.render_height_map_data)
	if v := e.blob_id {
		w.bool(true)
		w.le_u64(v)
	} else {
		w.bool(false)
	}
}

pub fn SubChunkDataEntry.decode(mut r serializer.Reader) !SubChunkDataEntry {
	mut e := SubChunkDataEntry{}
	e.sub_chunk_pos_offset = types_662.SubChunkPosOffset.decode(mut r)!
	e.sub_chunk_request_result = unsafe { SubChunkRequestResult(r.i8()!) }
	if r.bool()! {
		e.serialized_sub_chunk = r.read_string_bytes()!
	}
	e.height_map_data_type = unsafe { HeightMapDataType(r.i8()!) }
	if r.bool()! {
		e.height_map_data = decode_height_map(mut r)!
	}
	e.render_height_map_data_type = unsafe { HeightMapDataType(r.i8()!) }
	if r.bool()! {
		e.render_height_map_data = decode_height_map(mut r)!
	}
	if r.bool()! {
		e.blob_id = r.le_u64()!
	}
	return e
}

fn encode_opt_height_map(mut w serializer.Writer, present bool, data [16][16]i8) {
	w.bool(present)
	if present {
		for x in 0 .. 16 {
			for y in 0 .. 16 {
				w.i8(data[x][y])
			}
		}
	}
}

fn decode_height_map(mut r serializer.Reader) ![16][16]i8 {
	mut data := [16][16]i8{}
	for x in 0 .. 16 {
		for y in 0 .. 16 {
			data[x][y] = r.i8()!
		}
	}
	return data
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
	w.write_varuint32(u32(p.sub_chunk_data.len))
	for e in p.sub_chunk_data {
		e.encode(mut w)
	}
}

pub fn (mut p SubChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.cache_enabled = r.bool()!
	p.dimension_type = r.read_varint32()!
	p.center_pos = types.SubChunkPos.decode(mut r)!
	count := int(r.read_varuint32()!)
	p.sub_chunk_data = []SubChunkDataEntry{cap: count}
	for _ in 0 .. count {
		p.sub_chunk_data << SubChunkDataEntry.decode(mut r)!
	}
}
