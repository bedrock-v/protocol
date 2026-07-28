module types

import protocol.serializer

pub struct MapTrackedEntity {
pub mut:
	entity_id i64
}

pub struct MapTrackedBlock {
pub mut:
	position BlockPosition
}

pub type MapTrackedObject = MapTrackedBlock | MapTrackedEntity

pub fn (t MapTrackedObject) encode(mut w serializer.Writer) {
	match t {
		MapTrackedEntity {
			w.le_i32(0)
			w.write_varint64(t.entity_id)
		}
		MapTrackedBlock {
			w.le_i32(1)
			t.position.encode(mut w)
		}
	}
}

pub fn MapTrackedObject.decode(mut r serializer.Reader) !MapTrackedObject {
	object_type := r.le_i32()!
	match object_type {
		0 {
			return MapTrackedEntity{
				entity_id: r.read_varint64()!
			}
		}
		1 {
			return MapTrackedBlock{
				position: BlockPosition.decode(mut r)!
			}
		}
		else {
			return error('invalid MapTrackedObject type ${object_type}')
		}
	}
}
