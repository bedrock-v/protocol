module enums

import protocol.serializer

pub enum InteractionType as i32 {
	breeding              = 1
	taming                = 2
	curing                = 3
	crafted               = 4
	shearing              = 5
	milking               = 6
	trading               = 7
	feeding               = 8
	igniting              = 9
	coloring              = 10
	naming                = 11
	leashing              = 12
	unleashing            = 13
	pet_sleep             = 14
	trusting              = 15
	commanding            = 16
	@none                 = 0
	clear_item            = 17
	enchant_arrow         = 18
	compost_item_placed   = 19
	recovered_bonemeal    = 20
	book_placed           = 21
	book_opened           = 22
	disenchant            = 23
	repair                = 24
	disenchant_and_repair = 25
}

pub fn (e InteractionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InteractionType.decode(mut r serializer.Reader) !InteractionType {
	return unsafe { InteractionType(r.read_varint32()!) }
}
