module packets

import serializer
import version.v671.enums

pub struct CorrectPlayerMovePredictionPacket {
pub mut:
	prediction_type enums.PredictionType = enums.PredictionPlayer{}
	position        [3]f32
	velocity        [3]f32
	on_ground       bool
	tick            u64
}

pub fn (p &CorrectPlayerMovePredictionPacket) pid() u16 { return 161 }

pub fn (p &CorrectPlayerMovePredictionPacket) name() string { return 'CorrectPlayerMovePredictionPacket' }

pub fn (p &CorrectPlayerMovePredictionPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CorrectPlayerMovePredictionPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.prediction_type.id())
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	p.prediction_type.encode_payload(mut w)
	w.bool(p.on_ground)
	w.write_varuint64(p.tick)
}

pub fn (mut p CorrectPlayerMovePredictionPacket) decode_payload(mut r serializer.Reader) ! {
	d := r.u8()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.prediction_type = enums.PredictionType.decode_payload(d, mut r)!
	p.on_ground = r.bool()!
	p.tick = r.read_varuint64()!
}
