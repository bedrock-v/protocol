module enums

import serializer

pub enum PredictionType as i8 {
	player  = 0
	vehicle = 1
}

pub fn (e PredictionType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn PredictionType.decode(mut r serializer.Reader) !PredictionType {
	return unsafe { PredictionType(r.i8()!) }
}
