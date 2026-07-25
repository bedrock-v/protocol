module enums

import serializer

pub enum AuthoritativeMovementMode as i8 {
	client             = 0
	server             = 1
	server_with_rewind = 2
}

pub fn (e AuthoritativeMovementMode) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn AuthoritativeMovementMode.decode(mut r serializer.Reader) !AuthoritativeMovementMode {
	return unsafe { AuthoritativeMovementMode(r.i8()!) }
}
