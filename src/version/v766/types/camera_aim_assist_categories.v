module types

import serializer

pub struct CameraAimAssistCategories {
pub mut:
	identifier string
	categories []CameraAimAssistCategory
}

pub fn (t CameraAimAssistCategories) encode(mut w serializer.Writer) {
	w.write_string(t.identifier)
	w.write_varuint32(u32(t.categories.len))
	for e in t.categories {
		e.encode(mut w)
	}
}

pub fn CameraAimAssistCategories.decode(mut r serializer.Reader) !CameraAimAssistCategories {
	mut t := CameraAimAssistCategories{}
	t.identifier = r.read_string()!
	count := int(r.read_varuint32()!)
	t.categories = []CameraAimAssistCategory{cap: count}
	for _ in 0 .. count {
		t.categories << CameraAimAssistCategory.decode(mut r)!
	}
	return t
}
