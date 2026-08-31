module types

import protocol.serializer
import protocol.version.v291.types as types_291

pub enum StructureRotation as u8 {
	@none      = 0
	rotate_90  = 1
	rotate_180 = 2
	rotate_270 = 3
}

pub enum StructureMirror as u8 {
	@none = 0
	x     = 1
	z     = 2
	xz    = 3
}

pub enum StructureAnimationMode as u8 {
	@none  = 0
	layer  = 1
	blocks = 2
}

pub struct StructureSettings {
pub mut:
	palette_name             string
	ignoring_entities        bool
	ignoring_blocks          bool
	size                     types_291.BlockPosition
	offset                   types_291.BlockPosition
	last_edited_by_entity_id i64
	rotation                 StructureRotation
	mirror                   StructureMirror
	animation_mode           StructureAnimationMode
	animation_seconds        f32
	integrity_value          f32
	integrity_seed           i32
	pivot                    types_291.Vector3f
}

pub fn (t StructureSettings) encode(mut w serializer.Writer) {
	w.write_string(t.palette_name)
	w.bool(t.ignoring_entities)
	w.bool(t.ignoring_blocks)
	t.size.encode(mut w)
	t.offset.encode(mut w)
	w.write_varint64(t.last_edited_by_entity_id)
	w.u8(u8(t.rotation))
	w.u8(u8(t.mirror))
	w.u8(u8(t.animation_mode))
	w.le_f32(t.animation_seconds)
	w.le_f32(t.integrity_value)
	w.le_i32(t.integrity_seed)
	t.pivot.encode(mut w)
}

pub fn StructureSettings.decode(mut r serializer.Reader) !StructureSettings {
	return StructureSettings{
		palette_name:             r.read_string()!
		ignoring_entities:        r.bool()!
		ignoring_blocks:          r.bool()!
		size:                     types_291.BlockPosition.decode(mut r)!
		offset:                   types_291.BlockPosition.decode(mut r)!
		last_edited_by_entity_id: r.read_varint64()!
		rotation:                 unsafe { StructureRotation(r.u8()!) }
		mirror:                   unsafe { StructureMirror(r.u8()!) }
		animation_mode:           unsafe { StructureAnimationMode(r.u8()!) }
		animation_seconds:        r.le_f32()!
		integrity_value:          r.le_f32()!
		integrity_seed:           r.le_i32()!
		pivot:                    types_291.Vector3f.decode(mut r)!
	}
}
