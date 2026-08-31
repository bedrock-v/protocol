module enums

import protocol.serializer

pub enum ChatRestrictionLevel as i8 {
	@none    = 0
	dropped  = 1
	disabled = 2
}

pub fn (e ChatRestrictionLevel) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ChatRestrictionLevel.decode(mut r serializer.Reader) !ChatRestrictionLevel {
	return unsafe { ChatRestrictionLevel(r.i8()!) }
}
