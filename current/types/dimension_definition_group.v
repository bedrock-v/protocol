module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct DimensionDefinition {
pub mut:
	minimum_y      i32
	height_range   i32
	generator_type i32
	dimension_type i32
	pack_id        types_662.Uuid
	default_biome  string
}

pub fn (t DimensionDefinition) encode(mut w serializer.Writer) {
	w.write_varint32(t.minimum_y)
	w.write_varint32(t.height_range)
	w.write_varint32(t.generator_type)
	w.write_varint32(t.dimension_type)
	t.pack_id.encode(mut w)
	w.write_string(t.default_biome)
}

pub fn DimensionDefinition.decode(mut r serializer.Reader) !DimensionDefinition {
	return DimensionDefinition{
		minimum_y:      r.read_varint32()!
		height_range:   r.read_varint32()!
		generator_type: r.read_varint32()!
		dimension_type: r.read_varint32()!
		pack_id:        types_662.Uuid.decode(mut r)!
		default_biome:  r.read_string()!
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
	count := r.read_count()!
	mut items := []DimensionDefinitionGroupType{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << DimensionDefinitionGroupType.decode(mut r)!
	}
	return DimensionDefinitionGroup{
		definitions: items
	}
}
