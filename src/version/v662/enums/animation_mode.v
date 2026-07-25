module enums

import serializer

pub enum AnimationMode as i8 {
	@none  = 0
	layers = 1
	blocks = 2
}

pub fn (e AnimationMode) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn AnimationMode.decode(mut r serializer.Reader) !AnimationMode {
	return unsafe { AnimationMode(r.i8()!) }
}
