module src

import src.serializer

pub struct RequestChunkRadiusPacket {
pub mut:
	radius     int
	max_radius int
}

pub fn (p &RequestChunkRadiusPacket) pid() u16 {
	return request_chunk_radius_packet
}

pub fn (p &RequestChunkRadiusPacket) name() string {
	return 'RequestChunkRadiusPacket'
}

pub fn (p &RequestChunkRadiusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RequestChunkRadiusPacket) decode_payload(mut r serializer.Reader) ! {
	p.radius = int(r.read_varint32()!)
	p.max_radius = int(r.u8()!)
}

pub fn (p &RequestChunkRadiusPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.radius))
	w.u8(u8(p.max_radius))
}
