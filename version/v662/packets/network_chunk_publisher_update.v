module packets

import protocol.serializer
import protocol.version.v662.types

pub struct NetworkChunkPublisherUpdatePacket {
pub mut:
	new_view_position   types.BlockPos
	new_view_radius     u32
	server_built_chunks []types.ChunkPos
}

pub fn (p &NetworkChunkPublisherUpdatePacket) pid() u16 {
	return 121
}

pub fn (p &NetworkChunkPublisherUpdatePacket) name() string {
	return 'NetworkChunkPublisherUpdatePacket'
}

pub fn (p &NetworkChunkPublisherUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &NetworkChunkPublisherUpdatePacket) encode_payload(mut w serializer.Writer) {
	p.new_view_position.encode(mut w)
	w.write_varuint32(p.new_view_radius)
	w.le_u32(u32(p.server_built_chunks.len))
	for e in p.server_built_chunks {
		e.encode(mut w)
	}
}

pub fn (mut p NetworkChunkPublisherUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.new_view_position = types.BlockPos.decode(mut r)!
	p.new_view_radius = r.read_varuint32()!
	{
		count := int(r.le_u32()!)
		p.server_built_chunks = []types.ChunkPos{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.server_built_chunks << types.ChunkPos.decode(mut r)!
		}
	}
}
