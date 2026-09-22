module enums

import protocol.serializer

pub enum ItemUseMethod as i32 {
	unknown            = -1
	equip_armor        = 0
	eat                = 1
	attack             = 2
	consume            = 3
	throw              = 4
	shoot              = 5
	place              = 6
	fill_bottle        = 7
	fill_bucket        = 8
	pour_bucket        = 9
	use_tool           = 10
	interact           = 11
	retrieved          = 12
	dyed               = 13
	traded             = 14
	brushing_completed = 15
}

pub fn (e ItemUseMethod) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn ItemUseMethod.decode(mut r serializer.Reader) !ItemUseMethod {
	return unsafe { ItemUseMethod(r.le_i32()!) }
}
