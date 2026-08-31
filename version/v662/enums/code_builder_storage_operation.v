module enums

import protocol.serializer

pub enum CodeBuilderStorageOperation as i8 {
	@none = 0
	get   = 1
	set   = 2
	reset = 3
}

pub fn (e CodeBuilderStorageOperation) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CodeBuilderStorageOperation.decode(mut r serializer.Reader) !CodeBuilderStorageOperation {
	return unsafe { CodeBuilderStorageOperation(r.i8()!) }
}
