module enums

import protocol.serializer

pub enum LabTableReactionType as i8 {
	@none               = 0
	ice_bomb            = 1
	bleach              = 2
	elephant_toothpaste = 3
	fertilizer          = 4
	heat_block          = 5
	magnesium_salts     = 6
	misc_fire           = 7
	misc_explosion      = 8
	misc_lava           = 9
	misc_mystical       = 10
	misc_smoke          = 11
	misc_large_smoke    = 12
}

pub fn (e LabTableReactionType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn LabTableReactionType.decode(mut r serializer.Reader) !LabTableReactionType {
	return unsafe { LabTableReactionType(r.i8()!) }
}
