module types

import serializer

pub struct MoveActorDeltaData {
pub mut:
	actor_runtime_id ActorRuntimeID
	header           u16
	position_x       f32
	position_y       f32
	position_z       f32
	rotation_x       i8
	rotation_y       i8
	rotation_y_head  i8
}

pub fn (t MoveActorDeltaData) encode(mut w serializer.Writer) {
	t.actor_runtime_id.encode(mut w)
	w.le_u16(t.header)
	w.le_f32(t.position_x)
	w.le_f32(t.position_y)
	w.le_f32(t.position_z)
	w.i8(t.rotation_x)
	w.i8(t.rotation_y)
	w.i8(t.rotation_y_head)
}

pub fn MoveActorDeltaData.decode(mut r serializer.Reader) !MoveActorDeltaData {
	return MoveActorDeltaData{
		actor_runtime_id: ActorRuntimeID.decode(mut r)!
		header:           r.le_u16()!
		position_x:       r.le_f32()!
		position_y:       r.le_f32()!
		position_z:       r.le_f32()!
		rotation_x:       r.i8()!
		rotation_y:       r.i8()!
		rotation_y_head:  r.i8()!
	}
}
