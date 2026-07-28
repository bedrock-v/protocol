module packets

import protocol.serializer
import protocol.version.v662.types

pub struct SetActorDataPacket {
pub mut:
	target_runtime_id types.ActorRuntimeID
	actor_data        []types.DataItem
	synced_properties types.PropertySyncData
	tick              u64
}

pub fn (p &SetActorDataPacket) pid() u16 {
	return 39
}

pub fn (p &SetActorDataPacket) name() string {
	return 'SetActorDataPacket'
}

pub fn (p &SetActorDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetActorDataPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	w.write_varuint32(u32(p.actor_data.len))
	for e in p.actor_data {
		e.encode(mut w)
	}
	p.synced_properties.encode(mut w)
	w.write_varuint64(p.tick)
}

pub fn (mut p SetActorDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	{
		count := int(r.read_varuint32()!)
		p.actor_data = []types.DataItem{cap: count}
		for _ in 0 .. count {
			p.actor_data << types.DataItem.decode(mut r)!
		}
	}
	p.synced_properties = types.PropertySyncData.decode(mut r)!
	p.tick = r.read_varuint64()!
}
