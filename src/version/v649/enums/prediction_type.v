module enums

import serializer

pub enum PredictionType as u8 {
	player  = 0
	vehicle = 1
}

pub fn (e PredictionType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn PredictionType.decode(mut r serializer.Reader) !PredictionType {
	return unsafe { PredictionType(r.u8()!) }
}
