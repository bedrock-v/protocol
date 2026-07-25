module enums

import serializer

pub enum ServerAuthMovementMode as i32 {
	client_authoritative             = 0
	server_authoritative             = 1
	server_authoritative_with_rewind = 2
}

pub fn (e ServerAuthMovementMode) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ServerAuthMovementMode.decode(mut r serializer.Reader) !ServerAuthMovementMode {
	return unsafe { ServerAuthMovementMode(r.read_varint32()!) }
}
