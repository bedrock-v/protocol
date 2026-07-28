module enums

import protocol.serializer

pub enum StructureRedstoneSaveMode as u8 {
	saves_to_memory = 0
	saves_to_disk   = 1
}

pub fn (e StructureRedstoneSaveMode) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn StructureRedstoneSaveMode.decode(mut r serializer.Reader) !StructureRedstoneSaveMode {
	return unsafe { StructureRedstoneSaveMode(r.u8()!) }
}
