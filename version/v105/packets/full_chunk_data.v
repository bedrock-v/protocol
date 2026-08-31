module packets

import protocol.serializer

pub struct FullChunkDataPacket {
pub mut:
	chunk_x i32
	chunk_z i32
	data    []u8
}

pub fn (p &FullChunkDataPacket) pid() u16 {
	return 0x3b
}

pub fn (p &FullChunkDataPacket) name() string {
	return 'FullChunkDataPacket'
}

pub fn (p &FullChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &FullChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.chunk_x)
	w.write_varint32(p.chunk_z)
	w.write_string_bytes(p.data)
}

pub fn (mut p FullChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_x = r.read_varint32()!
	p.chunk_z = r.read_varint32()!
	p.data = r.read_string_bytes()!
}
