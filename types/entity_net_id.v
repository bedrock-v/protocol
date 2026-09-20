module types

import protocol.serializer

pub struct EntityNetID {
pub mut:
	raw_entity_id u32
}

pub fn (t EntityNetID) encode(mut w serializer.Writer) {
	w.write_varuint32(t.raw_entity_id)
}

pub fn EntityNetID.decode(mut r serializer.Reader) !EntityNetID {
	return EntityNetID{
		raw_entity_id: r.read_varuint32()!
	}
}
