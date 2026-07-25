module enums

import serializer

pub enum Difficulty as i32 {
	peaceful = 0
	easy     = 1
	normal   = 2
	hard     = 3
}

pub fn (e Difficulty) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn Difficulty.decode(mut r serializer.Reader) !Difficulty {
	return unsafe { Difficulty(r.read_varint32()!) }
}
