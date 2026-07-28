module types

import protocol.serializer

pub fn write_byte_angle(mut w serializer.Writer, angle f32) {
	w.i8(i8(angle / (360.0 / 256.0)))
}

pub fn read_byte_angle(mut r serializer.Reader) !f32 {
	return f32(r.i8()!) * (360.0 / 256.0)
}
