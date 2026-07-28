module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct SubChunkRequestPacket {
pub mut:
	dimension          i32
	sub_chunk_position types_291.Vector3i
}

pub fn (p &SubChunkRequestPacket) pid() u16 {
	return 175
}

pub fn (p &SubChunkRequestPacket) name() string {
	return 'SubChunkRequestPacket'
}

pub fn (p &SubChunkRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SubChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.dimension)
	p.sub_chunk_position.encode(mut w)
}

pub fn (mut p SubChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	p.sub_chunk_position = types_291.Vector3i.decode(mut r)!
}
