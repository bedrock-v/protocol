module types

import serializer
import version.v662.types as types_662
import version.v944.types as types_944

pub enum MapItemTrackedActorType as i32 {
	entity       = 0
	block_entity = 1
	other        = 2
}

pub fn (e MapItemTrackedActorType) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn MapItemTrackedActorType.decode(mut r serializer.Reader) !MapItemTrackedActorType {
	return unsafe { MapItemTrackedActorType(r.le_i32()!) }
}

pub struct MapItemTrackedActorUniqueID {
pub mut:
	unique_id_type MapItemTrackedActorType
	entity_id      ?types_662.ActorUniqueID
	block_position ?types_944.NetworkBlockPosition
}

pub fn (t MapItemTrackedActorUniqueID) encode(mut w serializer.Writer) {
	t.unique_id_type.encode(mut w)
	if v := t.entity_id {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.block_position {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn MapItemTrackedActorUniqueID.decode(mut r serializer.Reader) !MapItemTrackedActorUniqueID {
	mut t := MapItemTrackedActorUniqueID{}
	t.unique_id_type = MapItemTrackedActorType.decode(mut r)!
	if r.bool()! {
		t.entity_id = types_662.ActorUniqueID.decode(mut r)!
	}
	if r.bool()! {
		t.block_position = types_944.NetworkBlockPosition.decode(mut r)!
	}
	return t
}
