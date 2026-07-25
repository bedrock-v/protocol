module types

import serializer
import version.v662.types as types_662
import version.v662.enums

pub struct ActorLink {
pub mut:
	actor_unique_id_a        types_662.ActorUniqueID
	actor_unique_id_b        types_662.ActorUniqueID
	link_type                enums.ActorLinkType
	immediate                bool
	passenger_initiated      bool
	vehicle_angular_velocity f32
}

pub fn (t ActorLink) encode(mut w serializer.Writer) {
	t.actor_unique_id_a.encode(mut w)
	t.actor_unique_id_b.encode(mut w)
	t.link_type.encode(mut w)
	w.bool(t.immediate)
	w.bool(t.passenger_initiated)
	w.le_f32(t.vehicle_angular_velocity)
}

pub fn ActorLink.decode(mut r serializer.Reader) !ActorLink {
	return ActorLink{
		actor_unique_id_a:        types_662.ActorUniqueID.decode(mut r)!
		actor_unique_id_b:        types_662.ActorUniqueID.decode(mut r)!
		link_type:                enums.ActorLinkType.decode(mut r)!
		immediate:                r.bool()!
		passenger_initiated:      r.bool()!
		vehicle_angular_velocity: r.le_f32()!
	}
}
