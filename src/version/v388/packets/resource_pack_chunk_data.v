module packets

import protocol.serializer

pub struct ResourcePackChunkDataPacket {
pub mut:
	pack_id      string
	pack_version string
	chunk_index  i32
	progress     i64
	data         []u8
}

pub fn (p &ResourcePackChunkDataPacket) pid() u16 {
	return 83
}

pub fn (p &ResourcePackChunkDataPacket) name() string {
	return 'ResourcePackChunkDataPacket'
}

pub fn (p &ResourcePackChunkDataPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackChunkDataPacket) encode_payload(mut w serializer.Writer) {
	pack_info := if p.pack_version == '' { p.pack_id } else { '${p.pack_id}_${p.pack_version}' }
	w.write_string(pack_info)
	w.le_i32(p.chunk_index)
	w.le_i64(p.progress)
	w.write_string_bytes(p.data)
}

pub fn (mut p ResourcePackChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	pack_info := r.read_string()!.split_nth('_', 3)
	p.pack_id = pack_info[0]
	if pack_info.len > 1 {
		p.pack_version = pack_info[1]
	}
	p.chunk_index = r.le_i32()!
	p.progress = r.le_i64()!
	p.data = r.read_string_bytes()!
}
