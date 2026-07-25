module packets

import serializer

pub struct ChunkRadiusUpdatePacket {
pub mut:
	radius i32
}

pub fn (p &ChunkRadiusUpdatePacket) pid() u16 {
	return 0xc9
}

pub fn (p &ChunkRadiusUpdatePacket) name() string {
	return 'ChunkRadiusUpdatePacket'
}

pub fn (p &ChunkRadiusUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChunkRadiusUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.radius)
}

pub fn (mut p ChunkRadiusUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.radius = r.be_i32()!
}
