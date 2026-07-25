module enums

import serializer

pub enum SpawnBiomeType as i16 {
	default      = 0
	user_defined = 1
}

pub fn (e SpawnBiomeType) encode(mut w serializer.Writer) {
	w.le_i16(i16(e))
}

pub fn SpawnBiomeType.decode(mut r serializer.Reader) !SpawnBiomeType {
	return unsafe { SpawnBiomeType(r.le_i16()!) }
}
