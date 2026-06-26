module src

import src.serializer
import src.types

pub struct LabTablePacket {
pub mut:
	action_type    u8
	block_position types.BlockPosition
	reaction_type  u8
}

pub fn (p &LabTablePacket) pid() u16 {
	return lab_table_packet
}

pub fn (p &LabTablePacket) name() string {
	return 'LabTablePacket'
}

pub fn (p &LabTablePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LabTablePacket) decode_payload(mut r serializer.Reader) ! {
	p.action_type = r.u8()!
	p.block_position = r.read_block_position()!
	p.reaction_type = r.u8()!
}

pub fn (p &LabTablePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action_type)
	w.write_block_position(p.block_position)
	w.u8(p.reaction_type)
}
