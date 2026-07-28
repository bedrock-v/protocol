module packets

import protocol.serializer
import protocol.version.v827.enums

pub struct CorrectPlayerMovePredictionPacket {
pub mut:
	prediction_type          enums.PredictionType
	position                 [3]f32
	velocity                 [3]f32
	rotation                 [2]f32
	vehicle_angular_velocity ?f32
	on_ground                bool
	tick                     u64
}

pub fn (p &CorrectPlayerMovePredictionPacket) pid() u16 {
	return 161
}

pub fn (p &CorrectPlayerMovePredictionPacket) name() string {
	return 'CorrectPlayerMovePredictionPacket'
}

pub fn (p &CorrectPlayerMovePredictionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CorrectPlayerMovePredictionPacket) encode_payload(mut w serializer.Writer) {
	p.prediction_type.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	w.le_f32(p.rotation[0])
	w.le_f32(p.rotation[1])
	if v := p.vehicle_angular_velocity {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
	w.bool(p.on_ground)
	w.write_varuint64(p.tick)
}

pub fn (mut p CorrectPlayerMovePredictionPacket) decode_payload(mut r serializer.Reader) ! {
	p.prediction_type = enums.PredictionType.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.rotation = [r.le_f32()!, r.le_f32()!]!
	if r.bool()! {
		p.vehicle_angular_velocity = r.le_f32()!
	}
	p.on_ground = r.bool()!
	p.tick = r.read_varuint64()!
}
