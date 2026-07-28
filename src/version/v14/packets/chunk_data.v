module packets

import protocol.serializer

pub struct ChunkDataPacket {
pub mut:
	x    i32
	z    i32
	data []u8
}

pub fn (p &ChunkDataPacket) pid() u16 {
	return 0x9f
}

pub fn (p &ChunkDataPacket) name() string {
	return 'ChunkDataPacket'
}

pub fn (p &ChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.z)
	w.write_raw(p.data)
}

pub fn (mut p ChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.z = r.be_i32()!
	p.data = r.read_raw(r.remaining())!
}
