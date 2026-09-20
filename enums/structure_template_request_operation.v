module enums

import protocol.serializer

pub enum StructureTemplateRequestOperation as i8 {
	@none                 = 0
	export_from_save_mode = 1
	export_from_load_mode = 2
	query_saved_structure = 3
	@import               = 4
}

pub fn (e StructureTemplateRequestOperation) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn StructureTemplateRequestOperation.decode(mut r serializer.Reader) !StructureTemplateRequestOperation {
	return unsafe { StructureTemplateRequestOperation(r.i8()!) }
}
