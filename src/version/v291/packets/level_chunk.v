module packets

import serializer

pub struct LevelChunkPacket {
pub mut:
	chunk_x i32
	chunk_z i32
	data    []u8
}

pub fn (p &LevelChunkPacket) pid() u16 {
	return 58
}

pub fn (p &LevelChunkPacket) name() string {
	return 'LevelChunkPacket'
}

pub fn (p &LevelChunkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelChunkPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.chunk_x)
	w.write_varint32(p.chunk_z)
	w.write_string_bytes(p.data)
}

pub fn (mut p LevelChunkPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_x = r.read_varint32()!
	p.chunk_z = r.read_varint32()!
	p.data = r.read_string_bytes()!
}
