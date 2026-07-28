module types

import protocol.serializer
import protocol.version.v291.types as types_291

fn action_has_block_data(action i32) bool {
	return action in [i32(0), 1, 18, 26, 27]
}

pub struct PlayerBlockActionData {
pub mut:
	action         i32
	block_position types_291.Vector3i
	face           i32
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	w.write_varint32(t.action)
	if action_has_block_data(t.action) {
		t.block_position.encode(mut w)
		w.write_varint32(t.face)
	}
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	mut t := PlayerBlockActionData{}
	t.action = r.read_varint32()!
	if action_has_block_data(t.action) {
		t.block_position = types_291.Vector3i.decode(mut r)!
		t.face = r.read_varint32()!
	}
	return t
}
