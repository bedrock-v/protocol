module enums

import protocol.serializer

pub enum CodeBuilderStorageCategory as i8 {
	@none         = 0
	code_status   = 1
	instantiation = 2
	reset         = 3
}

pub fn (e CodeBuilderStorageCategory) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CodeBuilderStorageCategory.decode(mut r serializer.Reader) !CodeBuilderStorageCategory {
	return unsafe { CodeBuilderStorageCategory(r.i8()!) }
}
