module packets

import protocol.serializer

pub struct ResourcePackDataInfoPacket {
pub mut:
	pack_id              string
	pack_version         string
	max_chunk_size       i32
	chunk_count          i32
	compressed_pack_size i64
	hash                 []u8
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
	pack_info := if p.pack_version == '' { p.pack_id } else { '${p.pack_id}_${p.pack_version}' }
	w.write_string(pack_info)
	w.le_i32(p.max_chunk_size)
	w.le_i32(p.chunk_count)
	w.le_i64(p.compressed_pack_size)
	w.write_string_bytes(p.hash)
}

pub fn (mut p ResourcePackDataInfoPacket) decode_payload(mut r serializer.Reader) ! {
	pack_info := r.read_string()!.split_nth('_', 3)
	p.pack_id = pack_info[0]
	if pack_info.len > 1 {
		p.pack_version = pack_info[1]
	}
	p.max_chunk_size = r.le_i32()!
	p.chunk_count = r.le_i32()!
	p.compressed_pack_size = r.le_i64()!
	p.hash = r.read_string_bytes()!
}
