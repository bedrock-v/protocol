module types

import protocol.serializer

pub struct Uuid {
pub mut:
	bytes [16]u8
}

pub fn (t Uuid) encode(mut w serializer.Writer) {
	for b in t.bytes {
		w.u8(b)
	}
}

pub fn Uuid.decode(mut r serializer.Reader) !Uuid {
	mut u := Uuid{}
	for i in 0 .. 16 {
		u.bytes[i] = r.u8()!
	}
	return u
}
