module enums

import serializer

pub enum Mirror as i8 {
	@none = 0
	x     = 1
	z     = 2
	xz    = 3
}

pub fn (e Mirror) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn Mirror.decode(mut r serializer.Reader) !Mirror {
	return unsafe { Mirror(r.i8()!) }
}
