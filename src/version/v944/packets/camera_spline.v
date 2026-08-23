module packets

import protocol.serializer
import protocol.version.v944.types

pub struct CameraSplineDefinition {
pub mut:
	name        string
	instruction types.CameraSplineInstruction
}

pub fn (t CameraSplineDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	t.instruction.encode(mut w)
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
	for e in p.splines {
		e.encode(mut w)
	}
}

pub fn (mut p CameraSplinePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.splines = []CameraSplineDefinition{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.splines << CameraSplineDefinition.decode(mut r)!
	}
}
