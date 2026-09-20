module packets

import protocol.serializer

pub struct RequestChunkRadiusPacket {
pub mut:
	chunk_radius     i32
	max_chunk_radius i8
}

pub fn (p &RequestChunkRadiusPacket) pid() u16 {
	return 69
}

pub fn (p &RequestChunkRadiusPacket) name() string {
	return 'RequestChunkRadiusPacket'
}

pub fn (p &RequestChunkRadiusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestChunkRadiusPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.chunk_radius)
	w.i8(p.max_chunk_radius)
}

pub fn (mut p RequestChunkRadiusPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_radius = r.read_varint32()!
	p.max_chunk_radius = r.i8()!
}
