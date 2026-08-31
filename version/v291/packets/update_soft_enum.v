module packets

import protocol.serializer
import protocol.version.v291.types

pub enum SoftEnumUpdateType as u8 {
	add     = 0
	remove  = 1
	replace = 2
}

pub struct UpdateSoftEnumPacket {
pub mut:
	soft_enum   types.CommandEnumData
	update_type SoftEnumUpdateType
}

pub fn (p &UpdateSoftEnumPacket) pid() u16 {
	return 114
}

pub fn (p &UpdateSoftEnumPacket) name() string {
	return 'UpdateSoftEnumPacket'
}

pub fn (p &UpdateSoftEnumPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateSoftEnumPacket) encode_payload(mut w serializer.Writer) {
	p.soft_enum.encode(mut w)
	w.u8(u8(p.update_type))
}

pub fn (mut p UpdateSoftEnumPacket) decode_payload(mut r serializer.Reader) ! {
	p.soft_enum = types.CommandEnumData.decode(mut r, true)!
	p.update_type = unsafe { SoftEnumUpdateType(r.u8()!) }
}
