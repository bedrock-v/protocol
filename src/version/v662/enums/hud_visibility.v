module enums

import serializer

pub enum HudVisibility as i8 {
	hide  = 0
	reset = 1
}

pub fn (e HudVisibility) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn HudVisibility.decode(mut r serializer.Reader) !HudVisibility {
	return unsafe { HudVisibility(r.i8()!) }
}
