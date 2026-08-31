module enums

import protocol.serializer

pub enum GameType as i32 {
	survival        = 0
	creative        = 1
	adventure       = 2
	survival_viewer = 3
	creative_viewer = 4
	default         = 5
}

pub fn (e GameType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn GameType.decode(mut r serializer.Reader) !GameType {
	return unsafe { GameType(r.read_varint32()!) }
}
