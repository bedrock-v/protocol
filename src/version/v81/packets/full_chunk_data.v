module packets

import serializer

pub struct FullChunkDataPacket {
pub mut:
	chunk_x i32
	chunk_z i32
	order   u8
	data    []u8
}

pub fn (p &FullChunkDataPacket) pid() u16 {
	return 0x34
}

pub fn (p &FullChunkDataPacket) name() string {
	return 'FullChunkDataPacket'
}

pub fn (p &FullChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &FullChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.chunk_x)
	w.be_i32(p.chunk_z)
	w.u8(p.order)
	w.be_i32(i32(p.data.len))
	w.write_raw(p.data)
}

pub fn (mut p FullChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.chunk_x = r.be_i32()!
	p.chunk_z = r.be_i32()!
	p.order = r.u8()!
	dlen := int(r.be_i32()!)
	p.data = r.read_raw(dlen)!
}
