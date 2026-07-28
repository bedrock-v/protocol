module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct SubChunkRequestPacket {
pub mut:
	dimension          i32
	sub_chunk_position types_291.Vector3i
	position_offsets   [][3]i8
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
	w.le_i32(i32(p.position_offsets.len))
	for offset in p.position_offsets {
		w.i8(offset[0])
		w.i8(offset[1])
		w.i8(offset[2])
	}
}

pub fn (mut p SubChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	p.sub_chunk_position = types_291.Vector3i.decode(mut r)!
	offset_count := int(r.le_i32()!)
	p.position_offsets = [][3]i8{cap: offset_count}
	for _ in 0 .. offset_count {
		p.position_offsets << [r.i8()!, r.i8()!, r.i8()!]!
	}
}
