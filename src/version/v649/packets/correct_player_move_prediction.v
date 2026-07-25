module packets

import serializer
import version.v291.types as types_291
import version.v649.enums

pub struct CorrectPlayerMovePredictionPacket {
pub mut:
	position        types_291.Vector3f
	delta           types_291.Vector3f
	on_ground       bool
	tick            u64
	prediction_type enums.PredictionType
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
	p.position.encode(mut w)
	p.delta.encode(mut w)
	w.bool(p.on_ground)
	w.write_varuint64(p.tick)
	p.prediction_type.encode(mut w)
}

pub fn (mut p CorrectPlayerMovePredictionPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.Vector3f.decode(mut r)!
	p.delta = types_291.Vector3f.decode(mut r)!
	p.on_ground = r.bool()!
	p.tick = r.read_varuint64()!
	p.prediction_type = enums.PredictionType.decode(mut r)!
}
