module packets

import protocol.serializer
import protocol.version.v291.types

pub enum BlockSyncType as u64 {
	@none   = 0
	create  = 1
	destroy = 2
}

pub struct UpdateBlockSyncedPacket {
pub mut:
	block_position         types.BlockPosition
	definition             u32
	flags                  u32
	data_layer             u32
	runtime_entity_id      u64
	entity_block_sync_type BlockSyncType
}

pub fn (p &UpdateBlockSyncedPacket) pid() u16 {
	return 110
}

pub fn (p &UpdateBlockSyncedPacket) name() string {
	return 'UpdateBlockSyncedPacket'
}

pub fn (p &UpdateBlockSyncedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockSyncedPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_varuint32(p.definition)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.data_layer)
	w.write_varuint64(p.runtime_entity_id)
	w.write_varuint64(u64(p.entity_block_sync_type))
}

pub fn (mut p UpdateBlockSyncedPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.BlockPosition.decode(mut r)!
	p.definition = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.data_layer = r.read_varuint32()!
	p.runtime_entity_id = r.read_varuint64()!
	p.entity_block_sync_type = unsafe { BlockSyncType(r.read_varuint64()!) }
}
