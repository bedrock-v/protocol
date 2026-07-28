module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct SavedChunkPosition {
pub mut:
	x i32
	z i32
}

pub fn (t SavedChunkPosition) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varint32(t.z)
}

pub fn SavedChunkPosition.decode(mut r serializer.Reader) !SavedChunkPosition {
	return SavedChunkPosition{
		x: r.read_varint32()!
		z: r.read_varint32()!
	}
}

pub struct NetworkChunkPublisherUpdatePacket {
pub mut:
	position     types_291.Vector3i
	radius       u32
	saved_chunks []SavedChunkPosition
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
	p.position.encode(mut w)
	w.write_varuint32(p.radius)
	w.le_u32(u32(p.saved_chunks.len))
	for chunk in p.saved_chunks {
		chunk.encode(mut w)
	}
}

pub fn (mut p NetworkChunkPublisherUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.Vector3i.decode(mut r)!
	p.radius = r.read_varuint32()!
	chunk_count := int(r.le_u32()!)
	p.saved_chunks = []SavedChunkPosition{cap: chunk_count}
	for _ in 0 .. chunk_count {
		p.saved_chunks << SavedChunkPosition.decode(mut r)!
	}
}
