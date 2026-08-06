module types

import protocol.serializer

pub const move_actor_delta_flag_has_x = u16(1) << 0
pub const move_actor_delta_flag_has_y = u16(1) << 1
pub const move_actor_delta_flag_has_z = u16(1) << 2
pub const move_actor_delta_flag_has_rot_x = u16(1) << 3
pub const move_actor_delta_flag_has_rot_y = u16(1) << 4
pub const move_actor_delta_flag_has_rot_z = u16(1) << 5

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
	if t.header & move_actor_delta_flag_has_x != 0 {
		w.le_f32(t.position_x)
	}
	if t.header & move_actor_delta_flag_has_y != 0 {
		w.le_f32(t.position_y)
	}
	if t.header & move_actor_delta_flag_has_z != 0 {
		w.le_f32(t.position_z)
	}
	if t.header & move_actor_delta_flag_has_rot_x != 0 {
		w.i8(t.rotation_x)
	}
	if t.header & move_actor_delta_flag_has_rot_y != 0 {
		w.i8(t.rotation_y)
	}
	if t.header & move_actor_delta_flag_has_rot_z != 0 {
		w.i8(t.rotation_y_head)
	}
}

pub fn MoveActorDeltaData.decode(mut r serializer.Reader) !MoveActorDeltaData {
	mut t := MoveActorDeltaData{}
	t.actor_runtime_id = ActorRuntimeID.decode(mut r)!
	t.header = r.le_u16()!
	if t.header & move_actor_delta_flag_has_x != 0 {
		t.position_x = r.le_f32()!
	}
	if t.header & move_actor_delta_flag_has_y != 0 {
		t.position_y = r.le_f32()!
	}
	if t.header & move_actor_delta_flag_has_z != 0 {
		t.position_z = r.le_f32()!
	}
	if t.header & move_actor_delta_flag_has_rot_x != 0 {
		t.rotation_x = r.i8()!
	}
	if t.header & move_actor_delta_flag_has_rot_y != 0 {
		t.rotation_y = r.i8()!
	}
	if t.header & move_actor_delta_flag_has_rot_z != 0 {
		t.rotation_y_head = r.i8()!
	}
	return t
}
