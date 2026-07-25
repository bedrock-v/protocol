module enums

import serializer

pub enum StructureTemplateResponseType as i8 {
	@none   = 0
	export  = 1
	query   = 2
	@import = 3
}

pub fn (e StructureTemplateResponseType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn StructureTemplateResponseType.decode(mut r serializer.Reader) !StructureTemplateResponseType {
	return unsafe { StructureTemplateResponseType(r.i8()!) }
}
