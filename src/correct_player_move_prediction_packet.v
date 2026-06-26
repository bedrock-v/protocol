module src

import src.serializer
import src.types

pub struct CorrectPlayerMovePredictionPacket {
pub mut:
	prediction_type          u8
	position                 types.Vector3
	delta                    types.Vector3
	vehicle_rotation         types.Vector2
	vehicle_angular_velocity ?f32
	on_ground                bool
	tick                     u64
}

pub fn (p &CorrectPlayerMovePredictionPacket) pid() u16 {
	return correct_player_move_prediction_packet
}

pub fn (p &CorrectPlayerMovePredictionPacket) name() string {
	return 'CorrectPlayerMovePredictionPacket'
}

pub fn (p &CorrectPlayerMovePredictionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CorrectPlayerMovePredictionPacket) decode_payload(mut r serializer.Reader) ! {
	p.prediction_type = r.u8()!
	p.position = r.read_vector3()!
	p.delta = r.read_vector3()!
	p.vehicle_rotation = r.read_vector2()!
	if r.bool()! {
		p.vehicle_angular_velocity = r.le_f32()!
	} else {
		p.vehicle_angular_velocity = none
	}
	p.on_ground = r.bool()!
	p.tick = r.read_varuint64()!
}

pub fn (p &CorrectPlayerMovePredictionPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.prediction_type)
	w.write_vector3(p.position)
	w.write_vector3(p.delta)
	w.write_vector2(p.vehicle_rotation)
	if v := p.vehicle_angular_velocity {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
	w.bool(p.on_ground)
	w.write_varuint64(p.tick)
}
