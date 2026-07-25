module packets

import serializer

pub struct ResourcePackDataInfoPacket {
pub mut:
	pack_id              string
	max_chunk_size       i32
	chunk_count          i32
	compressed_pack_size i64
	sha256               string
}

pub fn (p &ResourcePackDataInfoPacket) pid() u16 {
	return 82
}

pub fn (p &ResourcePackDataInfoPacket) name() string {
	return 'ResourcePackDataInfoPacket'
}

pub fn (p &ResourcePackDataInfoPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackDataInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_i32(p.max_chunk_size)
	w.le_i32(p.chunk_count)
	w.le_i64(p.compressed_pack_size)
	w.write_string(p.sha256)
}

pub fn (mut p ResourcePackDataInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.max_chunk_size = r.le_i32()!
	p.chunk_count = r.le_i32()!
	p.compressed_pack_size = r.le_i64()!
	p.sha256 = r.read_string()!
}
