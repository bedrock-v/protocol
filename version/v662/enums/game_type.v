module enums

import protocol.serializer

pub enum GameType as i32 {
	undefined = -1
	survival  = 0
	creative  = 1
	adventure = 2
	default   = 5
	spectator = 6
}

pub fn (e GameType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn GameType.decode(mut r serializer.Reader) !GameType {
	return unsafe { GameType(r.read_varint32()!) }
}
