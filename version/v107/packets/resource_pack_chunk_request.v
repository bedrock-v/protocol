module packets

import protocol.serializer

pub struct ResourcePackChunkRequestPacket {
pub mut:
	pack_id     string
	chunk_index i32
}

pub fn (p &ResourcePackChunkRequestPacket) pid() u16 {
	return 0x54
}

pub fn (p &ResourcePackChunkRequestPacket) name() string {
	return 'ResourcePackChunkRequestPacket'
}

pub fn (p &ResourcePackChunkRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.pack_id)
	w.le_i32(p.chunk_index)
}

pub fn (mut p ResourcePackChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_string()!
	p.chunk_index = r.le_i32()!
}
