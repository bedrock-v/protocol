module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub enum LabTableType as i8 {
	start_combine  = 0
	start_reaction = 1
	reset          = 2
}

pub struct LabTablePacket {
pub mut:
	lab_table_packet_type LabTableType
	position              types.BlockPos
	reaction              enums.LabTableReactionType
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
	w.i8(i8(p.lab_table_packet_type))
	p.position.encode(mut w)
	p.reaction.encode(mut w)
}

pub fn (mut p LabTablePacket) decode_payload(mut r serializer.Reader) ! {
	p.lab_table_packet_type = unsafe { LabTableType(r.i8()!) }
	p.position = types.BlockPos.decode(mut r)!
	p.reaction = enums.LabTableReactionType.decode(mut r)!
}
