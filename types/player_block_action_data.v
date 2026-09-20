module types

import protocol.serializer
import protocol.enums

pub struct PlayerBlockActionData {
pub mut:
	action_type enums.PlayerActionType
	position    BlockPos
	facing      i32
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	t.position.encode(mut w)
	w.write_varint32(t.facing)
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	return PlayerBlockActionData{
		action_type: enums.PlayerActionType.decode(mut r)!
		position:    BlockPos.decode(mut r)!
		facing:      r.read_varint32()!
	}
}
