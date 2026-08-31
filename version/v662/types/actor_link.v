module types

import protocol.serializer
import protocol.version.v662.enums

pub struct ActorLink {
pub mut:
	actor_unique_id_a   ActorUniqueID
	actor_unique_id_b   ActorUniqueID
	link_type           enums.ActorLinkType
	immediate           bool
	passenger_initiated bool
}

pub fn (t ActorLink) encode(mut w serializer.Writer) {
	t.actor_unique_id_a.encode(mut w)
	t.actor_unique_id_b.encode(mut w)
	t.link_type.encode(mut w)
	w.bool(t.immediate)
	w.bool(t.passenger_initiated)
}

pub fn ActorLink.decode(mut r serializer.Reader) !ActorLink {
	return ActorLink{
		actor_unique_id_a:   ActorUniqueID.decode(mut r)!
		actor_unique_id_b:   ActorUniqueID.decode(mut r)!
		link_type:           enums.ActorLinkType.decode(mut r)!
		immediate:           r.bool()!
		passenger_initiated: r.bool()!
	}
}
