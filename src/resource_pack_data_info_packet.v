module protocol

import serializer

pub struct ResourcePackDataInfoPacket {
pub mut:
	pack_id              string
	max_chunk_size       int
	chunk_count          int
	compressed_pack_size u64
	sha256               string
	is_premium           bool
	pack_type            int
}

pub fn (p &ResourcePackDataInfoPacket) pid() u16 {
	return resource_pack_data_info_packet
}

pub fn (p &ResourcePackDataInfoPacket) name() string {
	return 'ResourcePackDataInfoPacket'
}

pub fn (p &ResourcePackDataInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePackDataInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.max_chunk_size = int(r.le_u32()!)
	p.chunk_count = int(r.le_u32()!)
	p.compressed_pack_size = r.le_u64()!
	p.sha256 = r.read_string()!
	p.is_premium = r.bool()!
	p.pack_type = int(r.u8()!)
}

pub fn (p &ResourcePackDataInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_u32(u32(p.max_chunk_size))
	w.le_u32(u32(p.chunk_count))
	w.le_u64(p.compressed_pack_size)
	w.write_string(p.sha256)
	w.bool(p.is_premium)
	w.u8(u8(p.pack_type))
}
