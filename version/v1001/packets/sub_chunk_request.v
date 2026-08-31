module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SubChunkRequestPacket {
pub mut:
	dimension_type        i32
	sub_chunk_pos_offsets []types.SubChunkPosOffset
	center_pos            [3]i32
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
	w.write_varint32(p.dimension_type)
	w.write_varuint32(u32(p.sub_chunk_pos_offsets.len))
	for e in p.sub_chunk_pos_offsets {
		e.encode(mut w)
	}
	w.le_i32(p.center_pos[0])
	w.le_i32(p.center_pos[1])
	w.le_i32(p.center_pos[2])
}

pub fn (mut p SubChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_type = r.read_varint32()!
	{
		count := r.read_count()!
		p.sub_chunk_pos_offsets = []types.SubChunkPosOffset{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.sub_chunk_pos_offsets << types.SubChunkPosOffset.decode(mut r)!
		}
	}
	p.center_pos = [r.le_i32()!, r.le_i32()!, r.le_i32()!]!
}
