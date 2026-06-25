module types

pub struct UUID {
pub mut:
	bytes [16]u8
}

pub fn uuid_from_bytes(b []u8) UUID {
	mut u := UUID{}
	for i := 0; i < 16 && i < b.len; i++ {
		u.bytes[i] = b[i]
	}
	return u
}

pub fn (u &UUID) to_array() []u8 {
	mut out := []u8{len: 16}
	for i in 0 .. 16 {
		out[i] = u.bytes[i]
	}
	return out
}
