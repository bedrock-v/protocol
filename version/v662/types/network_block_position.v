module types

import protocol.serializer

pub struct NetworkBlockPosition {
pub mut:
	x i32
	y u32
	z i32
}

pub fn (t NetworkBlockPosition) encode(mut w serializer.Writer) {
	w.write_varint32(t.x)
	w.write_varuint32(t.y)
	w.write_varint32(t.z)
}

pub fn NetworkBlockPosition.decode(mut r serializer.Reader) !NetworkBlockPosition {
	return NetworkBlockPosition{
		x: r.read_varint32()!
		y: r.read_varuint32()!
		z: r.read_varint32()!
	}
}
