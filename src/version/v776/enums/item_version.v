module enums

import serializer

pub enum ItemVersion as i32 {
	legacy      = 0
	data_driven = 1
	@none       = 2
}

pub fn (e ItemVersion) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ItemVersion.decode(mut r serializer.Reader) !ItemVersion {
	return unsafe { ItemVersion(r.read_varint32()!) }
}
