module enums

import serializer

pub enum PlayerPositionMode as i8 {
	normal        = 0
	respawn       = 1
	teleport      = 2
	only_head_rot = 3
}

pub fn (e PlayerPositionMode) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn PlayerPositionMode.decode(mut r serializer.Reader) !PlayerPositionMode {
	return unsafe { PlayerPositionMode(r.i8()!) }
}
