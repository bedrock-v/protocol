module types

import serializer
import version.v291.types as types_291

pub struct StructureSettings {
pub mut:
	palette_name             string
	ignoring_entities        bool
	ignoring_blocks          bool
	size                     types_291.BlockPosition
	offset                   types_291.BlockPosition
	last_edited_by_entity_id i64
	rotation                 u8
	mirror                   u8
	integrity_value          f32
	integrity_seed           i32
}

pub fn (t StructureSettings) encode(mut w serializer.Writer) {
	w.write_string(t.palette_name)
	w.bool(t.ignoring_entities)
	w.bool(t.ignoring_blocks)
	t.size.encode(mut w)
	t.offset.encode(mut w)
	w.write_varint64(t.last_edited_by_entity_id)
	w.u8(t.rotation)
	w.u8(t.mirror)
	w.le_f32(t.integrity_value)
	w.le_i32(t.integrity_seed)
}

pub fn StructureSettings.decode(mut r serializer.Reader) !StructureSettings {
	return StructureSettings{
		palette_name:             r.read_string()!
		ignoring_entities:        r.bool()!
		ignoring_blocks:          r.bool()!
		size:                     types_291.BlockPosition.decode(mut r)!
		offset:                   types_291.BlockPosition.decode(mut r)!
		last_edited_by_entity_id: r.read_varint64()!
		rotation:                 r.u8()!
		mirror:                   r.u8()!
		integrity_value:          r.le_f32()!
		integrity_seed:           r.le_i32()!
	}
}
