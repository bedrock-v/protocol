module packets

import protocol.serializer

pub struct RequestChunkPacket {
pub mut:
	x i32
	z i32
}

pub fn (p &RequestChunkPacket) pid() u16 {
	return 0x9e
}

pub fn (p &RequestChunkPacket) name() string {
	return 'RequestChunkPacket'
}

pub fn (p &RequestChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestChunkPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.z)
}

pub fn (mut p RequestChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.z = r.be_i32()!
}
