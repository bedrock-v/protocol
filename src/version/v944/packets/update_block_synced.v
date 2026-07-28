module packets

import protocol.serializer
import protocol.version.v662.enums
import protocol.version.v944.types

pub struct UpdateBlockSyncedPacket {
pub mut:
	block_position     types.NetworkBlockPosition
	block_runtime_id   u32
	flags              u32
	later              u32
	unique_actor_id    u64
	actor_sync_message enums.ActorBlockSyncMessageID
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
	w.write_varuint32(p.block_runtime_id)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.later)
	w.write_varuint64(p.unique_actor_id)
	p.actor_sync_message.encode(mut w)
}

pub fn (mut p UpdateBlockSyncedPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.block_runtime_id = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.later = r.read_varuint32()!
	p.unique_actor_id = r.read_varuint64()!
	p.actor_sync_message = enums.ActorBlockSyncMessageID.decode(mut r)!
}
