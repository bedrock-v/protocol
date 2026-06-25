module src

import src.serializer
import src.types

pub struct SetActorDataPacket {
pub mut:
	actor_runtime_id  u64
	metadata          []types.MetadataEntry
	synced_properties types.PropertySyncData
	tick              u64
}

pub fn (p &SetActorDataPacket) pid() u16 {
	return set_actor_data_packet
}

pub fn (p &SetActorDataPacket) name() string {
	return 'SetActorDataPacket'
}

pub fn (p &SetActorDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetActorDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.metadata = r.read_entity_metadata()!
	p.synced_properties = r.read_property_sync_data()!
	p.tick = r.read_varuint64()!
}

pub fn (p &SetActorDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_entity_metadata(p.metadata)
	w.write_property_sync_data(p.synced_properties)
	w.write_varuint64(p.tick)
}
