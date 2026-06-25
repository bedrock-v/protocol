module src

import src.serializer

pub struct ResourcePackChunkDataPacket {
pub mut:
	pack_id     string
	chunk_index int
	offset      u64
	data        []u8
}

pub fn (p &ResourcePackChunkDataPacket) pid() u16 {
	return resource_pack_chunk_data_packet
}

pub fn (p &ResourcePackChunkDataPacket) name() string {
	return 'ResourcePackChunkDataPacket'
}

pub fn (p &ResourcePackChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePackChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.chunk_index = int(r.le_u32()!)
	p.offset = r.le_u64()!
	p.data = r.read_string_bytes()!
}

pub fn (p &ResourcePackChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_u32(u32(p.chunk_index))
	w.le_u64(p.offset)
	w.write_string_bytes(p.data)
}
