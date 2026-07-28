module packets

import protocol.serializer

pub struct LevelChunkPacket {
pub mut:
	chunk_x           i32
	chunk_z           i32
	sub_chunks_length u32
	caching_enabled   bool
	blob_ids          []i64
	data              []u8
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
	w.write_varint32(p.chunk_x)
	w.write_varint32(p.chunk_z)
	w.write_varuint32(p.sub_chunks_length)
	w.bool(p.caching_enabled)
	if p.caching_enabled {
		w.write_varuint32(u32(p.blob_ids.len))
		for blob_id in p.blob_ids {
			w.le_i64(blob_id)
		}
	}
	w.write_string_bytes(p.data)
}

pub fn (mut p LevelChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_x = r.read_varint32()!
	p.chunk_z = r.read_varint32()!
	p.sub_chunks_length = r.read_varuint32()!
	p.caching_enabled = r.bool()!
	if p.caching_enabled {
		blob_count := int(r.read_varuint32()!)
		p.blob_ids = []i64{cap: blob_count}
		for _ in 0 .. blob_count {
			p.blob_ids << r.le_i64()!
		}
	}
	p.data = r.read_string_bytes()!
}
