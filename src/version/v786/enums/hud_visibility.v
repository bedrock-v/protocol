module enums

import serializer

pub enum HudVisibility as i32 {
	hide  = 0
	reset = 1
}

pub fn (e HudVisibility) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn HudVisibility.decode(mut r serializer.Reader) !HudVisibility {
	return unsafe { HudVisibility(r.read_varint32()!) }
}
