module enums

import protocol.serializer

pub struct PredictionPlayer {}

pub struct PredictionVehicle {
pub mut:
	rotation                 [2]f32
	vehicle_angular_velocity ?f32
}

pub type PredictionType = PredictionPlayer | PredictionVehicle

pub fn (t PredictionType) id() i8 {
	return match t {
		PredictionPlayer { i8(0) }
		PredictionVehicle { i8(1) }
	}
}

pub fn (t PredictionType) encode_payload(mut w serializer.Writer) {
	match t {
		PredictionVehicle {
			w.le_f32(t.rotation[0])
			w.le_f32(t.rotation[1])
			if v := t.vehicle_angular_velocity {
				w.bool(true)
				w.le_f32(v)
			} else {
				w.bool(false)
			}
		}
		else {}
	}
}

pub fn (t PredictionType) encode(mut w serializer.Writer) {
	w.i8(t.id())
	t.encode_payload(mut w)
}

pub fn PredictionType.decode_payload(id i8, mut r serializer.Reader) !PredictionType {
	match id {
		0 {
			return PredictionPlayer{}
		}
		1 {
			mut t := PredictionVehicle{}
			t.rotation = [r.le_f32()!, r.le_f32()!]!
			if r.bool()! {
				t.vehicle_angular_velocity = r.le_f32()!
			}
			return t
		}
		else {
			return error('invalid PredictionType ${id}')
		}
	}
}

pub fn PredictionType.decode(mut r serializer.Reader) !PredictionType {
	d := r.i8()!
	return PredictionType.decode_payload(d, mut r)!
}
