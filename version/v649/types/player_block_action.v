module types

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v649.enums

pub struct PlayerBlockActionData {
pub mut:
	action         enums.PlayerActionType
	block_position types_291.Vector3i
	face           i32
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	t.action.encode(mut w)
	match t.action {
		.start_break, .abort_break, .continue_break, .block_predict_destroy,
		.block_continue_destroy {
			t.block_position.encode(mut w)
			w.write_varint32(t.face)
		}
		else {}
	}
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	mut t := PlayerBlockActionData{}
	t.action = enums.PlayerActionType.decode(mut r)!
	match t.action {
		.start_break, .abort_break, .continue_break, .block_predict_destroy,
		.block_continue_destroy {
			t.block_position = types_291.Vector3i.decode(mut r)!
			t.face = r.read_varint32()!
		}
		else {}
	}
	return t
}
