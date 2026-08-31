module types

import protocol.serializer

pub struct ScoreboardId {
pub mut:
	id i64
}

pub fn (t ScoreboardId) encode(mut w serializer.Writer) {
	w.write_varint64(t.id)
}

pub fn ScoreboardId.decode(mut r serializer.Reader) !ScoreboardId {
	return ScoreboardId{
		id: r.read_varint64()!
	}
}
