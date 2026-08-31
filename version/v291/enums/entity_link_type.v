module enums

import protocol.serializer

pub enum EntityLinkType as u8 {
	remove    = 0
	rider     = 1
	passenger = 2
}

pub fn (e EntityLinkType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn EntityLinkType.decode(mut r serializer.Reader) !EntityLinkType {
	return unsafe { EntityLinkType(r.u8()!) }
}
