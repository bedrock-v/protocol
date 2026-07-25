module types

import serializer

pub struct StructureEditorData {
pub mut:
	name                 string
	data_field           string
	including_players    bool
	bounding_box_visible bool
	structure_block_type i32
	settings             StructureSettings
}

pub fn (t StructureEditorData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.data_field)
	w.bool(t.including_players)
	w.bool(t.bounding_box_visible)
	w.write_varint32(t.structure_block_type)
	t.settings.encode(mut w)
}

pub fn StructureEditorData.decode(mut r serializer.Reader) !StructureEditorData {
	return StructureEditorData{
		name:                 r.read_string()!
		data_field:           r.read_string()!
		including_players:    r.bool()!
		bounding_box_visible: r.bool()!
		structure_block_type: r.read_varint32()!
		settings:             StructureSettings.decode(mut r)!
	}
}
