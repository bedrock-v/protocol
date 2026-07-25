module types

import serializer
import version.v662.types as types_662
import version.v662.enums

pub struct StructureSettings {
pub mut:
	structure_palette_name                           string
	ignore_entities                                  bool
	ignore_locks                                     bool
	allow_non_ticking_player_and_ticking_area_chunks bool
	structure_size                                   NetworkBlockPosition
	structure_offset                                 NetworkBlockPosition
	last_edit_player                                 types_662.ActorUniqueID
	rotation                                         enums.Rotation
	mirror                                           enums.Mirror
	animation_mode                                   enums.AnimationMode
	animation_seconds                                f32
	integrity_value                                  f32
	integrity_seed                                   u32
	rotation_pivot_x                                 f32
	rotation_pivot_y                                 f32
	rotation_pivot_z                                 f32
}

pub fn (t StructureSettings) encode(mut w serializer.Writer) {
	w.write_string(t.structure_palette_name)
	w.bool(t.ignore_entities)
	w.bool(t.ignore_locks)
	w.bool(t.allow_non_ticking_player_and_ticking_area_chunks)
	t.structure_size.encode(mut w)
	t.structure_offset.encode(mut w)
	t.last_edit_player.encode(mut w)
	t.rotation.encode(mut w)
	t.mirror.encode(mut w)
	t.animation_mode.encode(mut w)
	w.le_f32(t.animation_seconds)
	w.le_f32(t.integrity_value)
	w.le_u32(t.integrity_seed)
	w.le_f32(t.rotation_pivot_x)
	w.le_f32(t.rotation_pivot_y)
	w.le_f32(t.rotation_pivot_z)
}

pub fn StructureSettings.decode(mut r serializer.Reader) !StructureSettings {
	return StructureSettings{
		structure_palette_name:                           r.read_string()!
		ignore_entities:                                  r.bool()!
		ignore_locks:                                     r.bool()!
		allow_non_ticking_player_and_ticking_area_chunks: r.bool()!
		structure_size:                                   NetworkBlockPosition.decode(mut r)!
		structure_offset:                                 NetworkBlockPosition.decode(mut r)!
		last_edit_player:                                 types_662.ActorUniqueID.decode(mut r)!
		rotation:                                         enums.Rotation.decode(mut r)!
		mirror:                                           enums.Mirror.decode(mut r)!
		animation_mode:                                   enums.AnimationMode.decode(mut r)!
		animation_seconds:                                r.le_f32()!
		integrity_value:                                  r.le_f32()!
		integrity_seed:                                   r.le_u32()!
		rotation_pivot_x:                                 r.le_f32()!
		rotation_pivot_y:                                 r.le_f32()!
		rotation_pivot_z:                                 r.le_f32()!
	}
}
