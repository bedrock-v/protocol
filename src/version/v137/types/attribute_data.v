module types

import protocol.serializer

pub struct AttributeData {
pub mut:
	min     f32
	max     f32
	current f32
	default f32
	name    string
}

pub fn (t AttributeData) encode(mut w serializer.Writer) {
	w.le_f32(t.min)
	w.le_f32(t.max)
	w.le_f32(t.current)
	w.le_f32(t.default)
	w.write_string(t.name)
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	return AttributeData{
		min:     r.le_f32()!
		max:     r.le_f32()!
		current: r.le_f32()!
		default: r.le_f32()!
		name:    r.read_string()!
	}
}

pub fn write_attribute_list(mut w serializer.Writer, list []AttributeData) {
	w.write_varuint32(u32(list.len))
	for a in list {
		a.encode(mut w)
	}
}

pub fn read_attribute_list(mut r serializer.Reader) ![]AttributeData {
	count := r.read_count()!
	mut list := []AttributeData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		list << AttributeData.decode(mut r)!
	}
	return list
}
