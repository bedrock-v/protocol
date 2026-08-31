module enums

import protocol.serializer

pub enum CommandPermissionLevel as i8 {
	any            = 0
	game_directors = 1
	admin          = 2
	host           = 3
	owner          = 4
	internal       = 5
}

pub fn (e CommandPermissionLevel) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CommandPermissionLevel.decode(mut r serializer.Reader) !CommandPermissionLevel {
	return unsafe { CommandPermissionLevel(r.i8()!) }
}
