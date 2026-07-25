module types

import serializer

pub struct ItemData {
pub mut:
	name               string
	id                 i16
	is_component_based bool
}

pub fn (t ItemData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_i16(t.id)
	w.bool(t.is_component_based)
}

pub fn ItemData.decode(mut r serializer.Reader) !ItemData {
	return ItemData{
		name:               r.read_string()!
		id:                 r.le_i16()!
		is_component_based: r.bool()!
	}
}
