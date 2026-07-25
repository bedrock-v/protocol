module types

import serializer

pub struct EntityLink {
pub mut:
	from_entity_unique_id i64
	to_entity_unique_id   i64
	link_type             u8
	immediate             u8
}

pub fn (t EntityLink) encode(mut w serializer.Writer) {
	w.write_varint64(t.from_entity_unique_id)
	w.write_varint64(t.to_entity_unique_id)
	w.u8(t.link_type)
	w.u8(t.immediate)
}

pub fn EntityLink.decode(mut r serializer.Reader) !EntityLink {
	return EntityLink{
		from_entity_unique_id: r.read_varint64()!
		to_entity_unique_id:   r.read_varint64()!
		link_type:             r.u8()!
		immediate:             r.u8()!
	}
}
