module enums

import serializer

pub enum HudVisibility as u8 {
	hide  = 0
	reset = 1
}

pub fn (e HudVisibility) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn HudVisibility.decode(mut r serializer.Reader) !HudVisibility {
	return unsafe { HudVisibility(r.u8()!) }
}
