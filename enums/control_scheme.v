module enums

import protocol.serializer

pub enum ControlScheme as i8 {
	locked_player_relative_strafe = 0
	camera_relative               = 1
	camera_relative_strafe        = 2
	player_relative               = 3
	player_relative_strafe        = 4
}

pub fn (e ControlScheme) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ControlScheme.decode(mut r serializer.Reader) !ControlScheme {
	return unsafe { ControlScheme(r.i8()!) }
}
