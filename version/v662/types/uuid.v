module types

import protocol.serializer

pub struct Uuid {
pub mut:
	bytes [16]u8
}

pub fn (t Uuid) encode(mut w serializer.Writer) {
	for i := 7; i >= 0; i-- {
		w.u8(t.bytes[i])
	}
	for i := 15; i >= 8; i-- {
		w.u8(t.bytes[i])
	}
}

pub fn Uuid.decode(mut r serializer.Reader) !Uuid {
	mut u := Uuid{}
	for i := 7; i >= 0; i-- {
		u.bytes[i] = r.u8()!
	}
	for i := 15; i >= 8; i-- {
		u.bytes[i] = r.u8()!
	}
	return u
}
