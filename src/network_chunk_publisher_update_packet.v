module src

import src.serializer
import src.types

pub struct NetworkChunkPublisherUpdatePacket {
pub mut:
	block_position types.BlockPosition
	radius         int
	saved_chunks   []types.ChunkPosition
}

pub fn (p &NetworkChunkPublisherUpdatePacket) pid() u16 {
	return network_chunk_publisher_update_packet
}

pub fn (p &NetworkChunkPublisherUpdatePacket) name() string {
	return 'NetworkChunkPublisherUpdatePacket'
}

pub fn (p &NetworkChunkPublisherUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p NetworkChunkPublisherUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.radius = int(r.read_varuint32()!)
	count := int(r.le_u32()!)
	p.saved_chunks = []types.ChunkPosition{cap: count}
	for _ in 0 .. count {
		p.saved_chunks << r.read_chunk_position()!
	}
}

pub fn (p &NetworkChunkPublisherUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_varuint32(u32(p.radius))
	w.le_u32(u32(p.saved_chunks.len))
	for chunk in p.saved_chunks {
		w.write_chunk_position(chunk)
	}
}
