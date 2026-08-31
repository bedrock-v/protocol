module enums

import protocol.serializer

pub enum SimulationType as i8 {
	game    = 0
	editor  = 1
	test    = 2
	invalid = 3
}

pub fn (e SimulationType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn SimulationType.decode(mut r serializer.Reader) !SimulationType {
	return unsafe { SimulationType(r.i8()!) }
}
