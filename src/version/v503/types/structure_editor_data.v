module types

import serializer

pub enum StructureBlockType as i32 {
	data    = 0
	save    = 1
	load    = 2
	corner  = 3
	invalid = 4
	export  = 5
}

pub enum StructureRedstoneSaveMode as i32 {
	saves_to_memory = 0
	saves_to_disk   = 1
}

pub struct StructureEditorData {
pub mut:
	name                 string
	data_field           string
	including_players    bool
	bounding_box_visible bool
	structure_block_type StructureBlockType
	settings             StructureSettings
	redstone_save_mode   StructureRedstoneSaveMode
}

pub fn (t StructureEditorData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.data_field)
	w.bool(t.including_players)
	w.bool(t.bounding_box_visible)
	w.write_varint32(i32(t.structure_block_type))
	t.settings.encode(mut w)
	w.write_varint32(i32(t.redstone_save_mode))
}

pub fn StructureEditorData.decode(mut r serializer.Reader) !StructureEditorData {
	return StructureEditorData{
		name:                 r.read_string()!
		data_field:           r.read_string()!
		including_players:    r.bool()!
		bounding_box_visible: r.bool()!
		structure_block_type: unsafe { StructureBlockType(r.read_varint32()!) }
		settings:             StructureSettings.decode(mut r)!
		redstone_save_mode:   unsafe { StructureRedstoneSaveMode(r.read_varint32()!) }
	}
}
