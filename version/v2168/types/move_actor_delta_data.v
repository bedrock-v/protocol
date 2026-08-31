module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct MoveActorDeltaData {
pub mut:
	actor_runtime_id        types_662.ActorRuntimeID
	position_x              ?f32
	position_y              ?f32
	position_z              ?f32
	rotation_x              ?i8
	rotation_y              ?i8
	rotation_y_head         ?i8
	on_ground               bool
	force_move              bool
	force_move_local_entity bool
	force_completion        bool
}

pub fn (t MoveActorDeltaData) encode(mut w serializer.Writer) {
	t.actor_runtime_id.encode(mut w)
	encode_opt_f32_le(mut w, t.position_x)
	encode_opt_f32_le(mut w, t.position_y)
	encode_opt_f32_le(mut w, t.position_z)
	encode_opt_i8(mut w, t.rotation_x)
	encode_opt_i8(mut w, t.rotation_y)
	encode_opt_i8(mut w, t.rotation_y_head)
	w.bool(t.on_ground)
	w.bool(t.force_move)
	w.bool(t.force_move_local_entity)
	w.bool(t.force_completion)
}

pub fn MoveActorDeltaData.decode(mut r serializer.Reader) !MoveActorDeltaData {
	mut t := MoveActorDeltaData{}
	t.actor_runtime_id = types_662.ActorRuntimeID.decode(mut r)!
	if r.bool()! {
		t.position_x = r.le_f32()!
	}
	if r.bool()! {
		t.position_y = r.le_f32()!
	}
	if r.bool()! {
		t.position_z = r.le_f32()!
	}
	if r.bool()! {
		t.rotation_x = r.i8()!
	}
	if r.bool()! {
		t.rotation_y = r.i8()!
	}
	if r.bool()! {
		t.rotation_y_head = r.i8()!
	}
	t.on_ground = r.bool()!
	t.force_move = r.bool()!
	t.force_move_local_entity = r.bool()!
	t.force_completion = r.bool()!
	return t
}

fn encode_opt_f32_le(mut w serializer.Writer, v ?f32) {
	if val := v {
		w.bool(true)
		w.le_f32(val)
	} else {
		w.bool(false)
	}
}

fn encode_opt_i8(mut w serializer.Writer, v ?i8) {
	if val := v {
		w.bool(true)
		w.i8(val)
	} else {
		w.bool(false)
	}
}
