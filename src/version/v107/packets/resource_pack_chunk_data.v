module packets

import serializer

pub struct ResourcePackChunkDataPacket {
pub mut:
	pack_id     string
	chunk_index i32
	progress    i64
	data        []u8
}

pub fn (p &ResourcePackChunkDataPacket) pid() u16 {
	return 0x53
}

pub fn (p &ResourcePackChunkDataPacket) name() string {
	return 'ResourcePackChunkDataPacket'
}

pub fn (p &ResourcePackChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_i32(p.chunk_index)
	w.le_i64(p.progress)
	w.le_i32(i32(p.data.len))
	w.write_raw(p.data)
}

pub fn (mut p ResourcePackChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.chunk_index = r.le_i32()!
	p.progress = r.le_i64()!
	data_len := int(r.le_i32()!)
	p.data = r.read_raw(data_len)!
}
