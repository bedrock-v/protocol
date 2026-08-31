module packets

import protocol.serializer

pub struct UnloadChunkPacket {
pub mut:
	chunk_x i32
	chunk_z i32
}

pub fn (p &UnloadChunkPacket) pid() u16 {
	return 0xbb
}

pub fn (p &UnloadChunkPacket) name() string {
	return 'UnloadChunkPacket'
}

pub fn (p &UnloadChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UnloadChunkPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.chunk_x)
	w.be_i32(p.chunk_z)
}

pub fn (mut p UnloadChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_x = r.be_i32()!
	p.chunk_z = r.be_i32()!
}
