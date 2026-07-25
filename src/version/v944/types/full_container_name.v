module types

import serializer
import version.v944.enums

pub struct FullContainerName {
pub mut:
	container  enums.ContainerEnumName
	dynamic_id ?i32
}

pub fn (t FullContainerName) encode(mut w serializer.Writer) {
	t.container.encode(mut w)
	if v := t.dynamic_id {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn FullContainerName.decode(mut r serializer.Reader) !FullContainerName {
	mut t := FullContainerName{}
	t.container = enums.ContainerEnumName.decode(mut r)!
	if r.bool()! {
		t.dynamic_id = r.le_i32()!
	}
	return t
}
