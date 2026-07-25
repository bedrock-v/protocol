module packets

import serializer

pub struct RequestChunkRadiusPacket {
pub mut:
	radius i32
}

pub fn (p &RequestChunkRadiusPacket) pid() u16 {
	return 0x40
}

pub fn (p &RequestChunkRadiusPacket) name() string {
	return 'RequestChunkRadiusPacket'
}

pub fn (p &RequestChunkRadiusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestChunkRadiusPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.radius)
}

pub fn (mut p RequestChunkRadiusPacket) decode_payload(mut r serializer.Reader) ! {
	p.radius = r.be_i32()!
}
