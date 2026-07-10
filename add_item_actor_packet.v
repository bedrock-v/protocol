module protocol


pub struct AddItemActorPacket {
pub mut:
	actor_unique_id  i64
	actor_runtime_id u64
	item             ItemStackWrapper
	position         Vector3
	motion           Vector3
	metadata         []MetadataEntry
	is_from_fishing  bool
}

pub fn (p &AddItemActorPacket) pid() u16 {
	return add_item_actor_packet
}

pub fn (p &AddItemActorPacket) name() string {
	return 'AddItemActorPacket'
}

pub fn (p &AddItemActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AddItemActorPacket) decode_payload(mut r Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.item = r.read_item_stack_wrapper()!
	p.position = r.read_vector3()!
	p.motion = r.read_vector3()!
	p.metadata = r.read_entity_metadata()!
	p.is_from_fishing = r.bool()!
}

pub fn (p &AddItemActorPacket) encode_payload(mut w Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_item_stack_wrapper(p.item)
	w.write_vector3(p.position)
	w.write_vector3(p.motion)
	w.write_entity_metadata(p.metadata)
	w.bool(p.is_from_fishing)
}
