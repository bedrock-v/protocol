module enums

import serializer

pub enum ResourcePackType as u8 {
	invalid        = 0
	resources      = 1
	data_add_on    = 2
	world_template = 3
	addon          = 4
	skins          = 5
	cached         = 6
	copy_protected = 7
}

pub fn (e ResourcePackType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn ResourcePackType.decode(mut r serializer.Reader) !ResourcePackType {
	return unsafe { ResourcePackType(r.u8()!) }
}
