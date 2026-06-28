module protocol

import serializer

pub struct ChunkRadiusUpdatedPacket {
pub mut:
	radius int
}

pub fn (p &ChunkRadiusUpdatedPacket) pid() u16 {
	return chunk_radius_updated_packet
}

pub fn (p &ChunkRadiusUpdatedPacket) name() string {
	return 'ChunkRadiusUpdatedPacket'
}

pub fn (p &ChunkRadiusUpdatedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ChunkRadiusUpdatedPacket) decode_payload(mut r serializer.Reader) ! {
	p.radius = int(r.read_varint32()!)
}

pub fn (p &ChunkRadiusUpdatedPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.radius))
}
