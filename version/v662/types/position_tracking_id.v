module types

import protocol.serializer

pub struct PositionTrackingId {
pub mut:
	value i32
}

pub fn (t PositionTrackingId) encode(mut w serializer.Writer) {
	w.write_varint32(t.value)
}

pub fn PositionTrackingId.decode(mut r serializer.Reader) !PositionTrackingId {
	return PositionTrackingId{
		value: r.read_varint32()!
	}
}
