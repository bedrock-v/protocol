module enums

import serializer

pub enum StructureRedstoneSaveMode as i32 {
	saves_to_memory = 0
	saves_to_disk   = 1
}

pub fn (e StructureRedstoneSaveMode) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn StructureRedstoneSaveMode.decode(mut r serializer.Reader) !StructureRedstoneSaveMode {
	return unsafe { StructureRedstoneSaveMode(r.read_varint32()!) }
}
