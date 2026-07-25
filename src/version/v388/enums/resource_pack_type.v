module enums

import serializer

pub enum ResourcePackType as u8 {
	invalid        = 0
	addon          = 1
	cached         = 2
	copy_protected = 3
	data_add_on    = 4
	persona_piece  = 5
	resources      = 6
	skins          = 7
	world_template = 8
}

pub fn (e ResourcePackType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn ResourcePackType.decode(mut r serializer.Reader) !ResourcePackType {
	return unsafe { ResourcePackType(r.u8()!) }
}
