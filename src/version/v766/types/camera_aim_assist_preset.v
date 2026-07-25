module types

import serializer

pub struct CameraAimAssistPreset {
pub mut:
	identifier  ?string
	target_mode ?i32
	angle       ?[2]f32
	distance    ?f32
}

pub fn (t CameraAimAssistPreset) encode(mut w serializer.Writer) {
	if v := t.identifier {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	if v := t.target_mode {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
	if v := t.angle {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	if v := t.distance {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraAimAssistPreset.decode(mut r serializer.Reader) !CameraAimAssistPreset {
	mut t := CameraAimAssistPreset{}
	if r.bool()! {
		t.identifier = r.read_string()!
	}
	if r.bool()! {
		t.target_mode = r.le_i32()!
	}
	if r.bool()! {
		t.angle = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.distance = r.le_f32()!
	}
	return t
}
