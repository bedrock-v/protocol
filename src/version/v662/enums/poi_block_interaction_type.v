module enums

import serializer

pub enum POIBlockInteractionType as i32 {
	@none                = 0
	extend               = 1
	clone                = 2
	lock                 = 3
	create               = 4
	create_locator       = 5
	rename               = 6
	item_placed          = 7
	item_removed         = 8
	cooking              = 9
	dousing              = 10
	lighting             = 11
	haystack             = 12
	filled               = 13
	emptied              = 14
	add_dye              = 15
	dye_item             = 16
	clear_item           = 17
	enchant_arrow        = 18
	compost_item_placed  = 19
	recovered_bonemeal   = 20
	book_placed          = 21
	book_opened          = 22
	disenchant           = 23
	repair               = 24
	disenchant_and_repair = 25
}

pub fn (e POIBlockInteractionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn POIBlockInteractionType.decode(mut r serializer.Reader) !POIBlockInteractionType {
	return unsafe { POIBlockInteractionType(r.read_varint32()!) }
}
