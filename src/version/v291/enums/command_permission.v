module enums

import protocol.serializer

pub enum CommandPermission as u8 {
	any            = 0
	game_directors = 1
	admin          = 2
	host           = 3
	owner          = 4
	internal       = 5
}

pub fn (e CommandPermission) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn CommandPermission.decode(mut r serializer.Reader) !CommandPermission {
	return unsafe { CommandPermission(r.u8()!) }
}
