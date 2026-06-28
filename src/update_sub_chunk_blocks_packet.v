module protocol

import serializer
import types

pub struct UpdateSubChunkBlocksEntry {
pub mut:
	block_position           types.BlockPosition
	block_runtime_id         u32
	update_flags             u32
	synced_update_actor_id   u64
	synced_update_type       u32
}

pub struct UpdateSubChunkBlocksPacket {
pub mut:
	base_block_position types.BlockPosition
	layer0_updates      []UpdateSubChunkBlocksEntry
	layer1_updates      []UpdateSubChunkBlocksEntry
}

pub fn (p &UpdateSubChunkBlocksPacket) pid() u16 {
	return update_sub_chunk_blocks_packet
}

pub fn (p &UpdateSubChunkBlocksPacket) name() string {
	return 'UpdateSubChunkBlocksPacket'
}

pub fn (p &UpdateSubChunkBlocksPacket) can_be_sent_before_login() bool {
	return false
}

fn read_sub_chunk_block_entries(mut r serializer.Reader) ![]UpdateSubChunkBlocksEntry {
	count := r.read_varuint32()!
	mut entries := []UpdateSubChunkBlocksEntry{}
	for _ in 0 .. count {
		entries << UpdateSubChunkBlocksEntry{
			block_position:         r.read_block_position()!
			block_runtime_id:       r.read_varuint32()!
			update_flags:           r.read_varuint32()!
			synced_update_actor_id: r.read_varuint64()!
			synced_update_type:     r.read_varuint32()!
		}
	}
	return entries
}

fn write_sub_chunk_block_entries(mut w serializer.Writer, entries []UpdateSubChunkBlocksEntry) {
	w.write_varuint32(u32(entries.len))
	for e in entries {
		w.write_block_position(e.block_position)
		w.write_varuint32(e.block_runtime_id)
		w.write_varuint32(e.update_flags)
		w.write_varuint64(e.synced_update_actor_id)
		w.write_varuint32(e.synced_update_type)
	}
}

pub fn (mut p UpdateSubChunkBlocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.base_block_position = r.read_block_position()!
	p.layer0_updates = read_sub_chunk_block_entries(mut r)!
	p.layer1_updates = read_sub_chunk_block_entries(mut r)!
}

pub fn (p &UpdateSubChunkBlocksPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.base_block_position)
	write_sub_chunk_block_entries(mut w, p.layer0_updates)
	write_sub_chunk_block_entries(mut w, p.layer1_updates)
}
