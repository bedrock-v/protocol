module types

import serializer

pub struct AttributeData {
pub mut:
	name          string
	minimum       f32
	maximum       f32
	value         f32
	default_value f32
}

pub fn (t AttributeData) encode(mut w serializer.Writer) {
	w.le_f32(t.minimum)
	w.le_f32(t.maximum)
	w.le_f32(t.value)
	w.le_f32(t.default_value)
	w.write_string(t.name)
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	return AttributeData{
		minimum:       r.le_f32()!
		maximum:       r.le_f32()!
		value:         r.le_f32()!
		default_value: r.le_f32()!
		name:          r.read_string()!
	}
}

pub fn (t AttributeData) encode_entity(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_f32(t.minimum)
	w.le_f32(t.maximum)
	w.le_f32(t.value)
}

pub fn AttributeData.decode_entity(mut r serializer.Reader) !AttributeData {
	return AttributeData{
		name:    r.read_string()!
		minimum: r.le_f32()!
		maximum: r.le_f32()!
		value:   r.le_f32()!
	}
}
