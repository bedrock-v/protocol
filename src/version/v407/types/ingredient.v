module types

import serializer

pub fn from_aux_value(value i32) i32 {
	if value == 0x7fff {
		return -1
	}
	return value
}

pub fn to_aux_value(value i32) i32 {
	if value == -1 {
		return 0x7fff
	}
	return value
}

pub struct Ingredient {
pub mut:
	runtime_id i32
	meta       i32
	count      i32
}

pub fn (t Ingredient) encode(mut w serializer.Writer) {
	if t.runtime_id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.runtime_id)
	w.write_varint32(to_aux_value(t.meta))
	w.write_varint32(t.count)
}

pub fn Ingredient.decode(mut r serializer.Reader) !Ingredient {
	mut t := Ingredient{}
	t.runtime_id = r.read_varint32()!
	if t.runtime_id == 0 {
		return t
	}
	t.meta = from_aux_value(r.read_varint32()!)
	t.count = r.read_varint32()!
	return t
}
