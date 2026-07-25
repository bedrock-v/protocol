module enums

import serializer

pub enum Rotation as i8 {
	@none     = 0
	rotate90  = 1
	rotate180 = 2
	rotate270 = 3
	total     = 4
}

pub fn (e Rotation) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn Rotation.decode(mut r serializer.Reader) !Rotation {
	return unsafe { Rotation(r.i8()!) }
}
