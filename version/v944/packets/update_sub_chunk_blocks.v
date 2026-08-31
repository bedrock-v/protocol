module packets

import protocol.serializer
import protocol.version.v662.enums
import protocol.version.v944.types

pub struct BlocksChangedEntry {
pub mut:
	pos                           types.NetworkBlockPosition
	runtime_id                    u32
	update_flags                  u32
	sync_message_entity_unique_id u64
	sync_message                  enums.ActorBlockSyncMessageID
}

pub fn (e BlocksChangedEntry) encode(mut w serializer.Writer) {
	e.pos.encode(mut w)
	w.write_varuint32(e.runtime_id)
	w.write_varuint32(e.update_flags)
	w.write_varuint64(e.sync_message_entity_unique_id)
	e.sync_message.encode(mut w)
}

pub fn BlocksChangedEntry.decode(mut r serializer.Reader) !BlocksChangedEntry {
	return BlocksChangedEntry{
		pos:                           types.NetworkBlockPosition.decode(mut r)!
		runtime_id:                    r.read_varuint32()!
		update_flags:                  r.read_varuint32()!
		sync_message_entity_unique_id: r.read_varuint64()!
		sync_message:                  enums.ActorBlockSyncMessageID.decode(mut r)!
	}
}

pub struct UpdateSubChunkBlocksPacket {
pub mut:
	sub_chunk_block_position types.NetworkBlockPosition
	standard_blocks_changed  []BlocksChangedEntry
	extra_blocks_changed     []BlocksChangedEntry
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
	p.sub_chunk_block_position.encode(mut w)
	w.write_varuint32(u32(p.standard_blocks_changed.len))
	for e in p.standard_blocks_changed {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.extra_blocks_changed.len))
	for e in p.extra_blocks_changed {
		e.encode(mut w)
	}
}

pub fn (mut p UpdateSubChunkBlocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.sub_chunk_block_position = types.NetworkBlockPosition.decode(mut r)!
	std_count := r.read_count()!
	p.standard_blocks_changed = []BlocksChangedEntry{cap: serializer.prealloc(std_count)}
	for _ in 0 .. std_count {
		p.standard_blocks_changed << BlocksChangedEntry.decode(mut r)!
	}
	extra_count := r.read_count()!
	p.extra_blocks_changed = []BlocksChangedEntry{cap: serializer.prealloc(extra_count)}
	for _ in 0 .. extra_count {
		p.extra_blocks_changed << BlocksChangedEntry.decode(mut r)!
	}
}
