module packets

import serializer
import version.v924.types

pub struct CameraSplineDefinition {
pub mut:
	name        string
	instruction types.CameraSplineInstruction
}

pub fn (e CameraSplineDefinition) encode(mut w serializer.Writer) {
	w.write_string(e.name)
	e.instruction.encode(mut w)
}

pub fn CameraSplineDefinition.decode(mut r serializer.Reader) !CameraSplineDefinition {
	return CameraSplineDefinition{
		name:        r.read_string()!
		instruction: types.CameraSplineInstruction.decode(mut r)!
	}
}

pub struct CameraSplinePacket {
pub mut:
	splines []CameraSplineDefinition
}

pub fn (p &CameraSplinePacket) pid() u16 {
	return 338
}

pub fn (p &CameraSplinePacket) name() string {
	return 'CameraSplinePacket'
}

pub fn (p &CameraSplinePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraSplinePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.splines.len))
	for s in p.splines {
		s.encode(mut w)
	}
}

pub fn (mut p CameraSplinePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.splines = []CameraSplineDefinition{cap: count}
	for _ in 0 .. count {
		p.splines << CameraSplineDefinition.decode(mut r)!
	}
}
