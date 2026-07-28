module packets

import protocol.serializer
import protocol.version.v662.types

pub struct AddItemActorPacket {
pub mut:
	target_actor_id   types.ActorUniqueID
	target_runtime_id types.ActorRuntimeID
	item              types.NetworkItemStackDescriptor
	position          [3]f32
	velocity          [3]f32
	entity_data       []types.DataItem
	from_fishing      bool
}

pub fn (p &AddItemActorPacket) pid() u16 {
	return 15
}

pub fn (p &AddItemActorPacket) name() string {
	return 'AddItemActorPacket'
}

pub fn (p &AddItemActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemActorPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	p.target_runtime_id.encode(mut w)
	p.item.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	w.write_varuint32(u32(p.entity_data.len))
	for e in p.entity_data {
		e.encode(mut w)
	}
	w.bool(p.from_fishing)
}

pub fn (mut p AddItemActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.item = types.NetworkItemStackDescriptor.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	{
		count := int(r.read_varuint32()!)
		p.entity_data = []types.DataItem{cap: count}
		for _ in 0 .. count {
			p.entity_data << types.DataItem.decode(mut r)!
		}
	}
	p.from_fishing = r.bool()!
}
