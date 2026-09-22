module enums

import protocol.serializer

pub enum CommandBlockMode as u32 {
	normal    = 0
	chain     = 2
	repeating = 1
}

pub fn (e CommandBlockMode) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn CommandBlockMode.decode(mut r serializer.Reader) !CommandBlockMode {
	return unsafe { CommandBlockMode(r.read_varuint32()!) }
}
