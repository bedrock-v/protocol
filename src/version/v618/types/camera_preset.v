module types

import serializer
import version.v618.enums

pub struct CameraPreset {
pub mut:
	identifier    string
	parent_preset string
	pos_x         ?f32
	pos_y         ?f32
	pos_z         ?f32
	pitch         ?f32
	yaw           ?f32
	listener      ?enums.CameraAudioListener
	play_effect   ?bool
}

pub fn (t CameraPreset) encode(mut w serializer.Writer) {
	w.write_string(t.identifier)
	w.write_string(t.parent_preset)
	encode_opt_f32_le(mut w, t.pos_x)
	encode_opt_f32_le(mut w, t.pos_y)
	encode_opt_f32_le(mut w, t.pos_z)
	encode_opt_f32_le(mut w, t.pitch)
	encode_opt_f32_le(mut w, t.yaw)
	if v := t.listener {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.play_effect {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraPreset.decode(mut r serializer.Reader) !CameraPreset {
	mut t := CameraPreset{}
	t.identifier = r.read_string()!
	t.parent_preset = r.read_string()!
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
		t.pitch = r.le_f32()!
	}
	if r.bool()! {
		t.yaw = r.le_f32()!
	}
	if r.bool()! {
		t.listener = enums.CameraAudioListener.decode(mut r)!
	}
	if r.bool()! {
		t.play_effect = r.bool()!
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
