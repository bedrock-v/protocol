module protocol

import serializer

pub const subchunk_result_success_all_air = u8(6)
pub const subchunk_heightmap_no_data = u8(0)
pub const subchunk_heightmap_data = u8(1)
pub const subchunk_heightmap_all_too_high = u8(2)
pub const subchunk_heightmap_all_too_low = u8(3)
pub const subchunk_heightmap_all_copied = u8(4)

pub struct SubChunkEntry {
pub mut:
	offset                SubChunkPositionOffset
	request_result        u8
	terrain_data          string
	height_map_type       u8
	height_map            []i8
	render_height_map_type u8
	render_height_map     []i8
	used_blob_hash        u64
}

pub struct SubChunkPacket {
pub mut:
	cache_enabled bool
	dimension     int
	base_x        int
	base_y        int
	base_z        int
	entries       []SubChunkEntry
}

pub fn (p &SubChunkPacket) pid() u16 {
	return sub_chunk_packet
}

pub fn (p &SubChunkPacket) name() string {
	return 'SubChunkPacket'
}

pub fn (p &SubChunkPacket) can_be_sent_before_login() bool {
	return false
}

fn read_subchunk_entry(mut r serializer.Reader, cache_enabled bool) !SubChunkEntry {
	mut e := SubChunkEntry{
		offset: SubChunkPositionOffset{
			x_offset: r.i8()!
			y_offset: r.i8()!
			z_offset: r.i8()!
		}
		request_result: r.u8()!
	}
	if !cache_enabled || e.request_result != subchunk_result_success_all_air {
		e.terrain_data = r.read_string()!
	}
	e.height_map_type = r.u8()!
	e.height_map = []i8{}
	if e.height_map_type == subchunk_heightmap_data {
		for _ in 0 .. 256 {
			e.height_map << r.i8()!
		}
	}
	e.render_height_map_type = r.u8()!
	e.render_height_map = []i8{}
	if e.render_height_map_type == subchunk_heightmap_data {
		for _ in 0 .. 256 {
			e.render_height_map << r.i8()!
		}
	}
	if cache_enabled {
		e.used_blob_hash = r.le_u64()!
	}
	return e
}

fn write_subchunk_entry(mut w serializer.Writer, e SubChunkEntry, cache_enabled bool) {
	w.i8(e.offset.x_offset)
	w.i8(e.offset.y_offset)
	w.i8(e.offset.z_offset)
	w.u8(e.request_result)
	if !cache_enabled || e.request_result != subchunk_result_success_all_air {
		w.write_string(e.terrain_data)
	}
	w.u8(e.height_map_type)
	if e.height_map_type == subchunk_heightmap_data {
		for h in e.height_map {
			w.i8(h)
		}
	}
	w.u8(e.render_height_map_type)
	if e.render_height_map_type == subchunk_heightmap_data {
		for h in e.render_height_map {
			w.i8(h)
		}
	}
	if cache_enabled {
		w.le_u64(e.used_blob_hash)
	}
}

pub fn (mut p SubChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.cache_enabled = r.bool()!
	p.dimension = r.read_varint32()!
	p.base_x = r.read_varint32()!
	p.base_y = r.read_varint32()!
	p.base_z = r.read_varint32()!
	count := r.le_u32()!
	p.entries = []SubChunkEntry{}
	for _ in 0 .. count {
		p.entries << read_subchunk_entry(mut r, p.cache_enabled)!
	}
}

pub fn (p &SubChunkPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.cache_enabled)
	w.write_varint32(p.dimension)
	w.write_varint32(p.base_x)
	w.write_varint32(p.base_y)
	w.write_varint32(p.base_z)
	w.le_u32(u32(p.entries.len))
	for e in p.entries {
		write_subchunk_entry(mut w, e, p.cache_enabled)
	}
}
