module types

import serializer
import version.v2168.enums
import version.v662.enums as enums_662
import version.v944.types as types_944

pub struct StructureEditorData {
pub mut:
	structure_name       RedactableString
	data_field           string
	include_players      bool
	show_bounding_box    bool
	structure_block_type enums_662.StructureBlockType
	structure_settings   types_944.StructureSettings
	redstone_save_mode   enums.StructureRedstoneSaveMode
}

pub fn (t StructureEditorData) encode(mut w serializer.Writer) {
	t.structure_name.encode(mut w)
	w.write_string(t.data_field)
	w.bool(t.include_players)
	w.bool(t.show_bounding_box)
	t.structure_block_type.encode(mut w)
	t.structure_settings.encode(mut w)
	t.redstone_save_mode.encode(mut w)
}

pub fn StructureEditorData.decode(mut r serializer.Reader) !StructureEditorData {
	return StructureEditorData{
		structure_name:       RedactableString.decode(mut r)!
		data_field:           r.read_string()!
		include_players:      r.bool()!
		show_bounding_box:    r.bool()!
		structure_block_type: enums_662.StructureBlockType.decode(mut r)!
		structure_settings:   types_944.StructureSettings.decode(mut r)!
		redstone_save_mode:   enums.StructureRedstoneSaveMode.decode(mut r)!
	}
}
