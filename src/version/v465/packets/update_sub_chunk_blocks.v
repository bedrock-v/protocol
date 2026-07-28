module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub enum BlockChangeMessageType as u32 {
	@none   = 0
	create  = 1
	destroy = 2
}

pub struct BlockChangeEntry {
pub mut:
	position          types_291.BlockPosition
	block_runtime_id  u32
	update_flags      u32
	message_entity_id u64
	message_type      BlockChangeMessageType
}

pub fn (t BlockChangeEntry) encode(mut w serializer.Writer) {
	t.position.encode(mut w)
	w.write_varuint32(t.block_runtime_id)
	w.write_varuint32(t.update_flags)
	w.write_varuint64(t.message_entity_id)
	w.write_varuint32(u32(t.message_type))
}

pub fn BlockChangeEntry.decode(mut r serializer.Reader) !BlockChangeEntry {
	return BlockChangeEntry{
		position:          types_291.BlockPosition.decode(mut r)!
		block_runtime_id:  r.read_varuint32()!
		update_flags:      r.read_varuint32()!
		message_entity_id: r.read_varuint64()!
		message_type:      unsafe { BlockChangeMessageType(r.read_varuint32()!) }
	}
}

pub struct UpdateSubChunkBlocksPacket {
pub mut:
	position        types_291.BlockPosition
	standard_blocks []BlockChangeEntry
	extra_blocks    []BlockChangeEntry
}

pub fn (p &UpdateSubChunkBlocksPacket) pid() u16 {
	return 172
}

pub fn (p &UpdateSubChunkBlocksPacket) name() string {
	return 'UpdateSubChunkBlocksPacket'
}

pub fn (p &UpdateSubChunkBlocksPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateSubChunkBlocksPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.write_varuint32(u32(p.standard_blocks.len))
	for entry in p.standard_blocks {
		entry.encode(mut w)
	}
	w.write_varuint32(u32(p.extra_blocks.len))
	for entry in p.extra_blocks {
		entry.encode(mut w)
	}
}

pub fn (mut p UpdateSubChunkBlocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.BlockPosition.decode(mut r)!
	standard_count := int(r.read_varuint32()!)
	p.standard_blocks = []BlockChangeEntry{cap: standard_count}
	for _ in 0 .. standard_count {
		p.standard_blocks << BlockChangeEntry.decode(mut r)!
	}
	extra_count := int(r.read_varuint32()!)
	p.extra_blocks = []BlockChangeEntry{cap: extra_count}
	for _ in 0 .. extra_count {
		p.extra_blocks << BlockChangeEntry.decode(mut r)!
	}
}
