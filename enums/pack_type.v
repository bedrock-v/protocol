module enums

import protocol.serializer

pub enum PackType as i8 {
	invalid        = 0
	addon          = 1
	cached         = 2
	copy_protected = 3
	behavior       = 4
	persona_piece  = 5
	resources      = 6
	skins          = 7
	world_template = 8
	count          = 9
}

pub fn (e PackType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn PackType.decode(mut r serializer.Reader) !PackType {
	return unsafe { PackType(r.i8()!) }
}
