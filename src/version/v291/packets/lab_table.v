module packets

import protocol.serializer
import protocol.version.v291.types

pub enum LabTableType as u8 {
	start_combine  = 0
	start_reaction = 1
	reset          = 2
}

pub enum LabTableReactionType as u8 {
	@none               = 0
	ice_bomb            = 1
	bleach              = 2
	elephant_toothpaste = 3
	fertilizer          = 4
	heat_block          = 5
	magnesium_salts     = 6
	misc_fire           = 7
	misc_explosion      = 8
	misc_laval          = 9
	misc_mystical       = 10
	misc_smoke          = 11
	misc_large_smoke    = 12
}

pub struct LabTablePacket {
pub mut:
	table_type    LabTableType
	position      types.Vector3i
	reaction_type LabTableReactionType
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
	w.u8(u8(p.table_type))
	p.position.encode(mut w)
	w.u8(u8(p.reaction_type))
}

pub fn (mut p LabTablePacket) decode_payload(mut r serializer.Reader) ! {
	p.table_type = unsafe { LabTableType(r.u8()!) }
	p.position = types.Vector3i.decode(mut r)!
	p.reaction_type = unsafe { LabTableReactionType(r.u8()!) }
}
