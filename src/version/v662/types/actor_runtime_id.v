module types

import serializer

pub struct ActorRuntimeID {
pub mut:
	value u64
}

pub fn (t ActorRuntimeID) encode(mut w serializer.Writer) {
	w.write_varuint64(t.value)
}

pub fn ActorRuntimeID.decode(mut r serializer.Reader) !ActorRuntimeID {
	return ActorRuntimeID{
		value: r.read_varuint64()!
	}
}
