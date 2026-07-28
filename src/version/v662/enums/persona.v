module enums

import protocol.serializer

pub enum AnimatedTextureType as u32 {
	@none       = 0
	face        = 1
	body32x32   = 2
	body128x128 = 3
}

pub fn (e AnimatedTextureType) encode(mut w serializer.Writer) {
	w.le_u32(u32(e))
}

pub fn AnimatedTextureType.decode(mut r serializer.Reader) !AnimatedTextureType {
	return unsafe { AnimatedTextureType(r.le_u32()!) }
}
