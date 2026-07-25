module types

import serializer
import version.v766.types as types_766

pub enum AudioListener as i8 {
	camera = 0
	player = 1
}

pub fn (e AudioListener) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn AudioListener.decode(mut r serializer.Reader) !AudioListener {
	return unsafe { AudioListener(r.i8()!) }
}

pub struct CameraPreset {
pub mut:
	name                             string
	inherit_from                     string
	pos_x                            ?f32
	pos_y                            ?f32
	pos_z                            ?f32
	rot_x                            ?f32
	rot_y                            ?f32
	rot_speed                        ?f32
	snap_to_target                   ?bool
	horizontal_rot_limit             ?[2]f32
	vertical_rot_limit               ?[2]f32
	continue_targeting               ?bool
	block_listening_radius           ?f32
	view_offset                      ?[2]f32
	entity_offset                    ?[3]f32
	radius                           ?f32
	min_yaw_limit                    ?f32
	max_yaw_limit                    ?f32
	listener                         ?AudioListener
	player_effects                   ?bool
	align_target_and_camera_forwards ?bool
	aim_assist_preset                ?types_766.CameraAimAssistPreset
}

pub fn (t CameraPreset) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.inherit_from)
	encode_opt_f32_le(mut w, t.pos_x)
	encode_opt_f32_le(mut w, t.pos_y)
	encode_opt_f32_le(mut w, t.pos_z)
	encode_opt_f32_le(mut w, t.rot_x)
	encode_opt_f32_le(mut w, t.rot_y)
	encode_opt_f32_le(mut w, t.rot_speed)
	encode_opt_bool(mut w, t.snap_to_target)
	if v := t.horizontal_rot_limit {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	if v := t.vertical_rot_limit {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	encode_opt_bool(mut w, t.continue_targeting)
	encode_opt_f32_le(mut w, t.block_listening_radius)
	if v := t.view_offset {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	if v := t.entity_offset {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
	encode_opt_f32_le(mut w, t.radius)
	encode_opt_f32_le(mut w, t.min_yaw_limit)
	encode_opt_f32_le(mut w, t.max_yaw_limit)
	if v := t.listener {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	encode_opt_bool(mut w, t.player_effects)
	encode_opt_bool(mut w, t.align_target_and_camera_forwards)
	if v := t.aim_assist_preset {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn CameraPreset.decode(mut r serializer.Reader) !CameraPreset {
	mut t := CameraPreset{}
	t.name = r.read_string()!
	t.inherit_from = r.read_string()!
	if r.bool()! {
		t.pos_x = r.le_f32()!
	}
	if r.bool()! {
		t.pos_y = r.le_f32()!
	}
	if r.bool()! {
		t.pos_z = r.le_f32()!
	}
	if r.bool()! {
		t.rot_x = r.le_f32()!
	}
	if r.bool()! {
		t.rot_y = r.le_f32()!
	}
	if r.bool()! {
		t.rot_speed = r.le_f32()!
	}
	if r.bool()! {
		t.snap_to_target = r.bool()!
	}
	if r.bool()! {
		t.horizontal_rot_limit = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.vertical_rot_limit = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.continue_targeting = r.bool()!
	}
	if r.bool()! {
		t.block_listening_radius = r.le_f32()!
	}
	if r.bool()! {
		t.view_offset = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.entity_offset = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.radius = r.le_f32()!
	}
	if r.bool()! {
		t.min_yaw_limit = r.le_f32()!
	}
	if r.bool()! {
		t.max_yaw_limit = r.le_f32()!
	}
	if r.bool()! {
		t.listener = AudioListener.decode(mut r)!
	}
	if r.bool()! {
		t.player_effects = r.bool()!
	}
	if r.bool()! {
		t.align_target_and_camera_forwards = r.bool()!
	}
	if r.bool()! {
		t.aim_assist_preset = types_766.CameraAimAssistPreset.decode(mut r)!
	}
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

fn encode_opt_bool(mut w serializer.Writer, v ?bool) {
	if val := v {
		w.bool(true)
		w.bool(val)
	} else {
		w.bool(false)
	}
}
