module enums

import serializer

pub struct PredictionPlayer {}

pub struct PredictionVehicle {
pub mut:
	rotation [2]f32
}

pub type PredictionType = PredictionPlayer | PredictionVehicle

pub fn (t PredictionType) id() u8 {
	return match t {
		PredictionPlayer { u8(0) }
		PredictionVehicle { u8(1) }
	}
}

pub fn (t PredictionType) encode_payload(mut w serializer.Writer) {
	match t {
		PredictionPlayer {}
		PredictionVehicle {
			w.le_f32(t.rotation[0])
			w.le_f32(t.rotation[1])
		}
	}
}

pub fn (t PredictionType) encode(mut w serializer.Writer) {
	w.u8(t.id())
	t.encode_payload(mut w)
}

pub fn PredictionType.decode(mut r serializer.Reader) !PredictionType {
	d := r.u8()!
	return PredictionType.decode_payload(d, mut r)!
}

pub fn PredictionType.decode_payload(d u8, mut r serializer.Reader) !PredictionType {
	match d {
		0 { return PredictionPlayer{} }
		1 { return PredictionVehicle{ rotation: [r.le_f32()!, r.le_f32()!]! } }
		else { return error('invalid PredictionType ${d}') }
	}
}
