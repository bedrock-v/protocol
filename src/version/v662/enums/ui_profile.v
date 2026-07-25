module enums

import serializer

pub enum UIProfile as u32 {
	classic = 0
	pocket  = 1
	@none   = 2
	count   = 3
}

pub fn (e UIProfile) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn UIProfile.decode(mut r serializer.Reader) !UIProfile {
	return unsafe { UIProfile(r.read_varuint32()!) }
}
