module packets

import serializer

pub struct ResourcePackChunkRequestPacket {
pub mut:
	pack_id      string
	pack_version string
	chunk_index  i32
}

pub fn (p &ResourcePackChunkRequestPacket) pid() u16 {
	return 84
}

pub fn (p &ResourcePackChunkRequestPacket) name() string {
	return 'ResourcePackChunkRequestPacket'
}

pub fn (p &ResourcePackChunkRequestPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	pack_info := if p.pack_version == '' { p.pack_id } else { '${p.pack_id}_${p.pack_version}' }
	w.write_string(pack_info)
	w.le_i32(p.chunk_index)
}

pub fn (mut p ResourcePackChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	pack_info := r.read_string()!.split_nth('_', 3)
	p.pack_id = pack_info[0]
	if pack_info.len > 1 {
		p.pack_version = pack_info[1]
	}
	p.chunk_index = r.le_i32()!
}
