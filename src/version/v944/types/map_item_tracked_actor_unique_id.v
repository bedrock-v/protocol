module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct MapItemTrackedEntity {
pub mut:
	actor_unique_id types_662.ActorUniqueID
}

pub struct MapItemTrackedBlockEntity {
pub mut:
	block_position NetworkBlockPosition
}

pub struct MapItemTrackedOther {}

pub type MapItemTrackedActorType = MapItemTrackedBlockEntity
	| MapItemTrackedEntity
	| MapItemTrackedOther

pub fn (t MapItemTrackedActorType) encode(mut w serializer.Writer) {
	match t {
		MapItemTrackedEntity {
			w.le_i32(0)
			t.actor_unique_id.encode(mut w)
		}
		MapItemTrackedBlockEntity {
			w.le_i32(1)
			t.block_position.encode(mut w)
		}
		MapItemTrackedOther {
			w.le_i32(2)
		}
	}
}

pub fn MapItemTrackedActorType.decode(mut r serializer.Reader) !MapItemTrackedActorType {
	d := r.le_i32()!
	match d {
		0 {
			return MapItemTrackedEntity{
				actor_unique_id: types_662.ActorUniqueID.decode(mut r)!
			}
		}
		1 {
			return MapItemTrackedBlockEntity{
				block_position: NetworkBlockPosition.decode(mut r)!
			}
		}
		2 {
			return MapItemTrackedOther{}
		}
		else {
			return error('invalid MapItemTrackedActorType ${d}')
		}
	}
}

pub struct MapItemTrackedActorUniqueID {
pub mut:
	unique_id_type MapItemTrackedActorType = MapItemTrackedOther{}
}

pub fn (t MapItemTrackedActorUniqueID) encode(mut w serializer.Writer) {
	t.unique_id_type.encode(mut w)
}

pub fn MapItemTrackedActorUniqueID.decode(mut r serializer.Reader) !MapItemTrackedActorUniqueID {
	return MapItemTrackedActorUniqueID{
		unique_id_type: MapItemTrackedActorType.decode(mut r)!
	}
}
