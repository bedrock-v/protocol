module types

import serializer
import version.v662.enums as enums_662

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
	view_offset                      ?[2]f32
	entity_offset                    ?[3]f32
	radius                           ?f32
	listener                         ?enums_662.AudioListener
	player_effects                   ?bool
	align_target_and_camera_forwards ?bool
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
	if v := t.snap_to_target {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
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
	if v := t.continue_targeting {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
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
	if v := t.listener {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.player_effects {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := t.align_target_and_camera_forwards {
		w.bool(true)
		w.bool(v)
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
		t.view_offset = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.entity_offset = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.radius = r.le_f32()!
	}
	if r.bool()! {
		t.listener = enums_662.AudioListener.decode(mut r)!
	}
	if r.bool()! {
		t.player_effects = r.bool()!
	}
	if r.bool()! {
		t.align_target_and_camera_forwards = r.bool()!
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
