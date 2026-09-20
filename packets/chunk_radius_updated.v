module packets

import protocol.serializer

pub struct ChunkRadiusUpdatedPacket {
pub mut:
	chunk_radius i32
}

pub fn (p &ChunkRadiusUpdatedPacket) pid() u16 {
	return 70
}

pub fn (p &ChunkRadiusUpdatedPacket) name() string {
	return 'ChunkRadiusUpdatedPacket'
}

pub fn (p &ChunkRadiusUpdatedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChunkRadiusUpdatedPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.chunk_radius)
}

pub fn (mut p ChunkRadiusUpdatedPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_radius = r.read_varint32()!
}
