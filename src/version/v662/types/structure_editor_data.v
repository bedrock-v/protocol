module types

import serializer
import version.v662.enums

pub struct StructureEditorData {
pub mut:
	structure_name       string
	data_field           string
	include_players      bool
	show_bounding_box    bool
	structure_block_type enums.StructureBlockType
	structure_settings   StructureSettings
	redstone_save_mode   enums.StructureRedstoneSaveMode
}

pub fn (t StructureEditorData) encode(mut w serializer.Writer) {
	w.write_string(t.structure_name)
	w.write_string(t.data_field)
	w.bool(t.include_players)
	w.bool(t.show_bounding_box)
	t.structure_block_type.encode(mut w)
	t.structure_settings.encode(mut w)
	t.redstone_save_mode.encode(mut w)
}

pub fn StructureEditorData.decode(mut r serializer.Reader) !StructureEditorData {
	return StructureEditorData{
		structure_name:       r.read_string()!
		data_field:           r.read_string()!
		include_players:      r.bool()!
		show_bounding_box:    r.bool()!
		structure_block_type: enums.StructureBlockType.decode(mut r)!
		structure_settings:   StructureSettings.decode(mut r)!
		redstone_save_mode:   enums.StructureRedstoneSaveMode.decode(mut r)!
	}
}
