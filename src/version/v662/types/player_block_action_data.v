module types

import protocol.serializer
import protocol.version.v662.enums

pub struct PlayerBlockActionData {
pub mut:
	action_type enums.PlayerActionType
	position    BlockPos
	facing      i32
}

fn is_block_destroy_action(a enums.PlayerActionType) bool {
	return a == .start_destroy_block || a == .abort_destroy_block || a == .crack_block
		|| a == .predict_destroy_block || a == .continue_destroy_block
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	if is_block_destroy_action(t.action_type) {
		t.position.encode(mut w)
		w.write_varint32(t.facing)
	}
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	mut t := PlayerBlockActionData{}
	t.action_type = enums.PlayerActionType.decode(mut r)!
	if is_block_destroy_action(t.action_type) {
		t.position = BlockPos.decode(mut r)!
		t.facing = r.read_varint32()!
	}
	return t
}
