module packets

import protocol.serializer

pub struct ResourcePackChunkDataPacket {
pub mut:
	resource_name string
	chunk_id      u32
	byte_offset   u64
	chunk_data    []u8
}

pub fn (p &ResourcePackChunkDataPacket) pid() u16 {
	return 83
}

pub fn (p &ResourcePackChunkDataPacket) name() string {
	return 'ResourcePackChunkDataPacket'
}

pub fn (p &ResourcePackChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.resource_name)
	w.le_u32(p.chunk_id)
	w.le_u64(p.byte_offset)
	w.write_string_bytes(p.chunk_data)
}

pub fn (mut p ResourcePackChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.resource_name = r.read_string()!
	p.chunk_id = r.le_u32()!
	p.byte_offset = r.le_u64()!
	p.chunk_data = r.read_string_bytes()!
}
