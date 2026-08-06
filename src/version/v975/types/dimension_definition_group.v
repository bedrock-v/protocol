module types

import protocol.serializer

pub struct DimensionDefinition {
pub mut:
	height_max     i32
	height_min     i32
	generator_type i32
	dimension_type i32
}

pub fn (t DimensionDefinition) encode(mut w serializer.Writer) {
	w.write_varint32(t.height_min)
	w.write_varint32(t.height_max)
	w.write_varint32(t.generator_type)
	w.write_varint32(t.dimension_type)
}

pub fn DimensionDefinition.decode(mut r serializer.Reader) !DimensionDefinition {
	min := r.read_varint32()!
	max := r.read_varint32()!
	return DimensionDefinition{
		height_max:     max
		height_min:     min
		generator_type: r.read_varint32()!
		dimension_type: r.read_varint32()!
	}
}

pub struct DimensionDefinitionGroupType {
pub mut:
	name                 string
	dimension_definition DimensionDefinition
}

pub fn (t DimensionDefinitionGroupType) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	t.dimension_definition.encode(mut w)
}

pub fn DimensionDefinitionGroupType.decode(mut r serializer.Reader) !DimensionDefinitionGroupType {
	return DimensionDefinitionGroupType{
		name:                 r.read_string()!
		dimension_definition: DimensionDefinition.decode(mut r)!
	}
}

pub struct DimensionDefinitionGroup {
pub mut:
	definitions []DimensionDefinitionGroupType
}

pub fn (t DimensionDefinitionGroup) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.definitions.len))
	for e in t.definitions {
		e.encode(mut w)
	}
}

pub fn DimensionDefinitionGroup.decode(mut r serializer.Reader) !DimensionDefinitionGroup {
	count := int(r.read_varuint32()!)
	mut items := []DimensionDefinitionGroupType{cap: count}
	for _ in 0 .. count {
		items << DimensionDefinitionGroupType.decode(mut r)!
	}
	return DimensionDefinitionGroup{
		definitions: items
	}
}
