module types

import protocol.serializer

pub struct EraBUuid {
pub mut:
	bytes [16]u8
}

pub fn (t EraBUuid) encode(mut w serializer.Writer) {
	for b in t.bytes {
		w.u8(b)
	}
}

pub fn EraBUuid.decode(mut r serializer.Reader) !EraBUuid {
	mut u := EraBUuid{}
	for i in 0 .. 16 {
		u.bytes[i] = r.u8()!
	}
	return u
}
