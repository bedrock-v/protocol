module enums

import serializer

pub enum CodeBuilderCodeStatus as i8 {
	@none       = 0
	not_started = 1
	in_progress = 2
	paused      = 3
	error       = 4
	succeeded   = 5
}

pub fn (e CodeBuilderCodeStatus) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CodeBuilderCodeStatus.decode(mut r serializer.Reader) !CodeBuilderCodeStatus {
	return unsafe { CodeBuilderCodeStatus(r.i8()!) }
}
