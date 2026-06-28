module protocol

import serializer
import types

pub struct UpdateBlockSyncedPacket {
pub mut:
	block_position   types.BlockPosition
	block_runtime_id int
	flags            int
	data_layer_id    int
	actor_unique_id  u64
	update_type      u64
}

pub fn (p &UpdateBlockSyncedPacket) pid() u16 {
	return update_block_synced_packet
}

pub fn (p &UpdateBlockSyncedPacket) name() string {
	return 'UpdateBlockSyncedPacket'
}

pub fn (p &UpdateBlockSyncedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateBlockSyncedPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.block_runtime_id = int(r.read_varuint32()!)
	p.flags = int(r.read_varuint32()!)
	p.data_layer_id = int(r.read_varuint32()!)
	p.actor_unique_id = r.read_varuint64()!
	p.update_type = r.read_varuint64()!
}

pub fn (p &UpdateBlockSyncedPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_varuint32(u32(p.block_runtime_id))
	w.write_varuint32(u32(p.flags))
	w.write_varuint32(u32(p.data_layer_id))
	w.write_varuint64(p.actor_unique_id)
	w.write_varuint64(p.update_type)
}
