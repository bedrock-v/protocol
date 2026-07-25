module packets

import serializer
import version.v137.types

pub struct UpdateBlockSyncedPacket {
pub mut:
	position         types.BlockPosition
	block_runtime_id u32
	flags            u32
	data_layer_id    u32
	uvarint64_1      u64
	uvarint64_2      u64
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
	p.position.encode(mut w)
	w.write_varuint32(p.block_runtime_id)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.data_layer_id)
	w.write_varuint64(p.uvarint64_1)
	w.write_varuint64(p.uvarint64_2)
}

pub fn (mut p UpdateBlockSyncedPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.block_runtime_id = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.data_layer_id = r.read_varuint32()!
	p.uvarint64_1 = r.read_varuint64()!
	p.uvarint64_2 = r.read_varuint64()!
}
