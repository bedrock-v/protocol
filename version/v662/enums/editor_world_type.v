module enums

import protocol.serializer

pub enum EditorWorldType as i32 {
	non_editor        = 0
	editor_project    = 1
	editor_test_level = 2
}

pub fn (e EditorWorldType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn EditorWorldType.decode(mut r serializer.Reader) !EditorWorldType {
	return unsafe { EditorWorldType(r.read_varint32()!) }
}
