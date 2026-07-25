module types

import serializer
import version.v662.types as types_662
import version.v662.enums as enums_662

pub struct PlayerBlockActionData {
pub mut:
	action_type enums_662.PlayerActionType
	position    types_662.BlockPos
	facing      i32
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	t.position.encode(mut w)
	w.write_varint32(t.facing)
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	return PlayerBlockActionData{
		action_type: enums_662.PlayerActionType.decode(mut r)!
		position:    types_662.BlockPos.decode(mut r)!
		facing:      r.read_varint32()!
	}
}
