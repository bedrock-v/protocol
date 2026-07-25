module enums

import serializer

pub enum StructureBlockType as i32 {
	data    = 0
	save    = 1
	load    = 2
	corner  = 3
	invalid = 4
	export  = 5
	count   = 6
}

pub fn (e StructureBlockType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn StructureBlockType.decode(mut r serializer.Reader) !StructureBlockType {
	return unsafe { StructureBlockType(r.read_varint32()!) }
}
