module enums

import serializer

pub enum PlayerPermission as u32 {
	visitor  = 0
	member   = 1
	operator = 2
	custom   = 3
}

pub fn (e PlayerPermission) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn PlayerPermission.decode(mut r serializer.Reader) !PlayerPermission {
	return unsafe { PlayerPermission(r.read_varuint32()!) }
}
