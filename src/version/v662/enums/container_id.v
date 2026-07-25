module enums

import serializer

pub enum ContainerID as i8 {
	@none           = -1
	inventory       = 0
	first           = 1
	last            = 100
	offhand         = 119
	armor           = 120
	selection_slots = 122
	player_only_ui  = 124
}

pub fn (e ContainerID) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ContainerID.decode(mut r serializer.Reader) !ContainerID {
	return unsafe { ContainerID(r.i8()!) }
}
