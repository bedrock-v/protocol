module enums

import serializer

pub enum ActorLinkType as i8 {
	@none     = 0
	riding    = 1
	passenger = 2
}

pub fn (e ActorLinkType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ActorLinkType.decode(mut r serializer.Reader) !ActorLinkType {
	return unsafe { ActorLinkType(r.i8()!) }
}
