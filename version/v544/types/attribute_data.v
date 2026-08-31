module types

import protocol.serializer

pub struct AttributeModifierData {
pub mut:
	id           string
	name         string
	amount       f32
	operation    i32
	operand      i32
	serializable bool
}

pub fn (t AttributeModifierData) encode(mut w serializer.Writer) {
	w.write_string(t.id)
	w.write_string(t.name)
	w.le_f32(t.amount)
	w.le_i32(t.operation)
	w.le_i32(t.operand)
	w.bool(t.serializable)
}

pub fn AttributeModifierData.decode(mut r serializer.Reader) !AttributeModifierData {
	return AttributeModifierData{
		id:           r.read_string()!
		name:         r.read_string()!
		amount:       r.le_f32()!
		operation:    r.le_i32()!
		operand:      r.le_i32()!
		serializable: r.bool()!
	}
}

pub struct AttributeData {
pub mut:
	name          string
	minimum       f32
	maximum       f32
	value         f32
	default_value f32
	modifiers     []AttributeModifierData
}

pub fn (t AttributeData) encode(mut w serializer.Writer) {
	w.le_f32(t.minimum)
	w.le_f32(t.maximum)
	w.le_f32(t.value)
	w.le_f32(t.default_value)
	w.write_string(t.name)
	w.write_varuint32(u32(t.modifiers.len))
	for modifier in t.modifiers {
		modifier.encode(mut w)
	}
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	mut t := AttributeData{}
	t.minimum = r.le_f32()!
	t.maximum = r.le_f32()!
	t.value = r.le_f32()!
	t.default_value = r.le_f32()!
	t.name = r.read_string()!
	modifier_count := r.read_count()!
	t.modifiers = []AttributeModifierData{cap: serializer.prealloc(modifier_count)}
	for _ in 0 .. modifier_count {
		t.modifiers << AttributeModifierData.decode(mut r)!
	}
	return t
}
