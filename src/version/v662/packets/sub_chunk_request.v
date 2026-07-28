module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SubChunkRequestPacket {
pub mut:
	dimension_type        i32
	center_pos            types.SubChunkPos
	sub_chunk_pos_offsets []types.SubChunkPosOffset
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
	p.center_pos.encode(mut w)
	w.le_u32(u32(p.sub_chunk_pos_offsets.len))
	for e in p.sub_chunk_pos_offsets {
		e.encode(mut w)
	}
}

pub fn (mut p SubChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_type = r.read_varint32()!
	p.center_pos = types.SubChunkPos.decode(mut r)!
	{
		count := int(r.le_u32()!)
		p.sub_chunk_pos_offsets = []types.SubChunkPosOffset{cap: count}
		for _ in 0 .. count {
			p.sub_chunk_pos_offsets << types.SubChunkPosOffset.decode(mut r)!
		}
	}
}
