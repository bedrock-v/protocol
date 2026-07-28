module enums

import protocol.serializer

pub enum PhotoType as i8 {
	portfolio  = 0
	photo_item = 1
	book       = 2
}

pub fn (e PhotoType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn PhotoType.decode(mut r serializer.Reader) !PhotoType {
	return unsafe { PhotoType(r.i8()!) }
}
