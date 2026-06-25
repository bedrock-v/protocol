module src

import src.serializer

pub struct ResourcePackChunkRequestPacket {
pub mut:
	pack_id     string
	chunk_index int
}

pub fn (p &ResourcePackChunkRequestPacket) pid() u16 {
	return resource_pack_chunk_request_packet
}

pub fn (p &ResourcePackChunkRequestPacket) name() string {
	return 'ResourcePackChunkRequestPacket'
}

pub fn (p &ResourcePackChunkRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePackChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.chunk_index = int(r.le_u32()!)
}

pub fn (p &ResourcePackChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_u32(u32(p.chunk_index))
}
