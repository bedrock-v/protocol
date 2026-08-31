module enums

import protocol.serializer

pub enum PlayerPermissionLevel as i32 {
	visitor  = 0
	member   = 1
	operator = 2
	custom   = 3
}

pub fn (e PlayerPermissionLevel) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PlayerPermissionLevel.decode(mut r serializer.Reader) !PlayerPermissionLevel {
	return unsafe { PlayerPermissionLevel(r.read_varint32()!) }
}
