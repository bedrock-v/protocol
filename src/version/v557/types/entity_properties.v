module types

import protocol.serializer

pub struct IntEntityProperty {
pub mut:
	index u32
	value i32
}

pub struct FloatEntityProperty {
pub mut:
	index u32
	value f32
}

pub struct EntityProperties {
pub mut:
	int_properties   []IntEntityProperty
	float_properties []FloatEntityProperty
}

pub fn (t EntityProperties) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.int_properties.len))
	for property in t.int_properties {
		w.write_varuint32(property.index)
		w.write_varint32(property.value)
	}
	w.write_varuint32(u32(t.float_properties.len))
	for property in t.float_properties {
		w.write_varuint32(property.index)
		w.le_f32(property.value)
	}
}

pub fn EntityProperties.decode(mut r serializer.Reader) !EntityProperties {
	int_count := r.read_count()!
	mut int_properties := []IntEntityProperty{cap: serializer.prealloc(int_count)}
	for _ in 0 .. int_count {
		int_properties << IntEntityProperty{
			index: r.read_varuint32()!
			value: r.read_varint32()!
		}
	}
	float_count := r.read_count()!
	mut float_properties := []FloatEntityProperty{cap: serializer.prealloc(float_count)}
	for _ in 0 .. float_count {
		float_properties << FloatEntityProperty{
			index: r.read_varuint32()!
			value: r.le_f32()!
		}
	}
	return EntityProperties{
		int_properties:   int_properties
		float_properties: float_properties
	}
}
