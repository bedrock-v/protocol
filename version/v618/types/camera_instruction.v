module types

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v618.enums

pub struct CameraEaseData {
pub mut:
	ease_type enums.CameraEase
	time      f32
}

pub fn (t CameraEaseData) encode(mut w serializer.Writer) {
	t.ease_type.encode(mut w)
	w.le_f32(t.time)
}

pub fn CameraEaseData.decode(mut r serializer.Reader) !CameraEaseData {
	return CameraEaseData{
		ease_type: enums.CameraEase.decode(mut r)!
		time:      r.le_f32()!
	}
}

pub struct CameraSetInstruction {
pub mut:
	preset_runtime_id i32
	ease              ?CameraEaseData
	pos               ?types_291.Vector3f
	rot               ?types_291.Vector2f
	facing            ?types_291.Vector3f
	default_preset    ?bool
}

pub fn (t CameraSetInstruction) encode(mut w serializer.Writer) {
	w.le_i32(t.preset_runtime_id)
	if v := t.ease {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.pos {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.rot {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.facing {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.default_preset {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraSetInstruction.decode(mut r serializer.Reader) !CameraSetInstruction {
	mut t := CameraSetInstruction{}
	t.preset_runtime_id = r.le_i32()!
	if r.bool()! {
		t.ease = CameraEaseData.decode(mut r)!
	}
	if r.bool()! {
		t.pos = types_291.Vector3f.decode(mut r)!
	}
	if r.bool()! {
		t.rot = types_291.Vector2f.decode(mut r)!
	}
	if r.bool()! {
		t.facing = types_291.Vector3f.decode(mut r)!
	}
	if r.bool()! {
		t.default_preset = r.bool()!
	}
	return t
}

pub struct CameraFadeTimeData {
pub mut:
	fade_in_time  f32
	wait_time     f32
	fade_out_time f32
}

pub fn (t CameraFadeTimeData) encode(mut w serializer.Writer) {
	w.le_f32(t.fade_in_time)
	w.le_f32(t.wait_time)
	w.le_f32(t.fade_out_time)
}

pub fn CameraFadeTimeData.decode(mut r serializer.Reader) !CameraFadeTimeData {
	return CameraFadeTimeData{
		fade_in_time:  r.le_f32()!
		wait_time:     r.le_f32()!
		fade_out_time: r.le_f32()!
	}
}

pub struct CameraFadeColor {
pub mut:
	r f32
	g f32
	b f32
}

pub fn (t CameraFadeColor) encode(mut w serializer.Writer) {
	w.le_f32(t.r)
	w.le_f32(t.g)
	w.le_f32(t.b)
}

pub fn CameraFadeColor.decode(mut r serializer.Reader) !CameraFadeColor {
	return CameraFadeColor{
		r: r.le_f32()!
		g: r.le_f32()!
		b: r.le_f32()!
	}
}

pub struct CameraFadeInstruction {
pub mut:
	time_data ?CameraFadeTimeData
	color     ?CameraFadeColor
}

pub fn (t CameraFadeInstruction) encode(mut w serializer.Writer) {
	if v := t.time_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.color {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn CameraFadeInstruction.decode(mut r serializer.Reader) !CameraFadeInstruction {
	mut t := CameraFadeInstruction{}
	if r.bool()! {
		t.time_data = CameraFadeTimeData.decode(mut r)!
	}
	if r.bool()! {
		t.color = CameraFadeColor.decode(mut r)!
	}
	return t
}
