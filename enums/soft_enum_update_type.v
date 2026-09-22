module enums

import protocol.serializer

pub enum SoftEnumUpdateType as u32 {
	add     = 0
	remove  = 1
	replace = 2
}

pub fn (e SoftEnumUpdateType) encode(mut w serializer.Writer) {
	w.le_u32(u32(e))
}

pub fn SoftEnumUpdateType.decode(mut r serializer.Reader) !SoftEnumUpdateType {
	return unsafe { SoftEnumUpdateType(r.le_u32()!) }
}
