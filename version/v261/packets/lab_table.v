module packets

import protocol.serializer
import protocol.version.v137.types

pub struct LabTablePacket {
pub mut:
	useless_byte  u8
	position      types.Vector3i
	reaction_type u8
}

pub fn (p &LabTablePacket) pid() u16 {
	return 109
}

pub fn (p &LabTablePacket) name() string {
	return 'LabTablePacket'
}

pub fn (p &LabTablePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LabTablePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.useless_byte)
	p.position.encode(mut w)
	w.u8(p.reaction_type)
}

pub fn (mut p LabTablePacket) decode_payload(mut r serializer.Reader) ! {
	p.useless_byte = r.u8()!
	p.position = types.Vector3i.decode(mut r)!
	p.reaction_type = r.u8()!
}
