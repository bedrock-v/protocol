module packets

import protocol.serializer

pub struct ChunkRadiusUpdatedPacket {
pub mut:
	radius i32
}

pub fn (p &ChunkRadiusUpdatedPacket) pid() u16 {
	return 0x44
}

pub fn (p &ChunkRadiusUpdatedPacket) name() string {
	return 'ChunkRadiusUpdatedPacket'
}

pub fn (p &ChunkRadiusUpdatedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChunkRadiusUpdatedPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.radius)
}

pub fn (mut p ChunkRadiusUpdatedPacket) decode_payload(mut r serializer.Reader) ! {
	p.radius = r.read_varint32()!
}
