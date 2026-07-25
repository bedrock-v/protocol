module enums

import serializer

pub struct ActorType {
pub mut:
	value i32
}

pub fn (t ActorType) encode(mut w serializer.Writer) {
	w.write_varint32(t.value)
}

pub fn ActorType.decode(mut r serializer.Reader) !ActorType {
	return ActorType{
		value: r.read_varint32()!
	}
}
