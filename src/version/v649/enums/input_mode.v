module enums

import serializer

pub enum InputMode as u32 {
	undefined         = 0
	mouse             = 1
	touch             = 2
	gamepad           = 3
	motion_controller = 4
}

pub fn (e InputMode) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InputMode.decode(mut r serializer.Reader) !InputMode {
	return unsafe { InputMode(r.read_varuint32()!) }
}
