module types

import protocol.serializer

pub struct ActorUniqueID {
pub mut:
	value i64
}

pub fn (t ActorUniqueID) encode(mut w serializer.Writer) {
	w.write_varint64(t.value)
}

pub fn ActorUniqueID.decode(mut r serializer.Reader) !ActorUniqueID {
	return ActorUniqueID{
		value: r.read_varint64()!
	}
}
