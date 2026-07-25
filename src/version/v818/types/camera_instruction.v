module types

import serializer
import version.v662.types as types_662
import version.v662.enums

pub struct EaseData {
pub mut:
	ease_type enums.EasingType
	ease_time f32
}

pub fn (t EaseData) encode(mut w serializer.Writer) {
	t.ease_type.encode(mut w)
	w.le_f32(t.ease_time)
}

pub fn EaseData.decode(mut r serializer.Reader) !EaseData {
	return EaseData{
		ease_type: enums.EasingType.decode(mut r)!
		ease_time: r.le_f32()!
	}
}

pub struct SetInstruction {
pub mut:
	runtime_id                              i32
	ease_data                               ?EaseData
	position                                ?[3]f32
	rotation                                ?[2]f32
	facing                                  ?[3]f32
	view_offset                             ?[2]f32
	entity_offset                           ?[3]f32
	default_preset                          ?bool
	remove_ignore_starting_values_component bool
}

pub fn (t SetInstruction) encode(mut w serializer.Writer) {
	w.le_i32(t.runtime_id)
	if v := t.ease_data {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.position {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
	if v := t.rotation {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	if v := t.facing {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
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
	if v := t.default_preset {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	w.bool(t.remove_ignore_starting_values_component)
}

pub fn SetInstruction.decode(mut r serializer.Reader) !SetInstruction {
	mut t := SetInstruction{}
	t.runtime_id = r.le_i32()!
	if r.bool()! {
		t.ease_data = EaseData.decode(mut r)!
	}
	if r.bool()! {
		t.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.rotation = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.facing = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.view_offset = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.entity_offset = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.default_preset = r.bool()!
	}
	t.remove_ignore_starting_values_component = r.bool()!
	return t
}

pub struct TimeData {
pub mut:
	fade_in_time  f32
	wait_time     f32
	fade_out_time f32
}

pub fn (t TimeData) encode(mut w serializer.Writer) {
	w.le_f32(t.fade_in_time)
	w.le_f32(t.wait_time)
	w.le_f32(t.fade_out_time)
}

pub fn TimeData.decode(mut r serializer.Reader) !TimeData {
	return TimeData{
		fade_in_time:  r.le_f32()!
		wait_time:     r.le_f32()!
		fade_out_time: r.le_f32()!
	}
}

pub struct Color {
pub mut:
	r f32
	g f32
	b f32
}

pub fn (t Color) encode(mut w serializer.Writer) {
	w.le_f32(t.r)
	w.le_f32(t.g)
	w.le_f32(t.b)
}

pub fn Color.decode(mut r serializer.Reader) !Color {
	return Color{
		r: r.le_f32()!
		g: r.le_f32()!
		b: r.le_f32()!
	}
}

pub struct FadeInstruction {
pub mut:
	time_data ?TimeData
	color     ?Color
}

pub fn (t FadeInstruction) encode(mut w serializer.Writer) {
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

pub fn FadeInstruction.decode(mut r serializer.Reader) !FadeInstruction {
	mut t := FadeInstruction{}
	if r.bool()! {
		t.time_data = TimeData.decode(mut r)!
	}
	if r.bool()! {
		t.color = Color.decode(mut r)!
	}
	return t
}

pub struct TargetInstruction {
pub mut:
	target_center_offset ?[3]f32
	actor_unique_id      types_662.ActorUniqueID
}

pub fn (t TargetInstruction) encode(mut w serializer.Writer) {
	if v := t.target_center_offset {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
	t.actor_unique_id.encode(mut w)
}

pub fn TargetInstruction.decode(mut r serializer.Reader) !TargetInstruction {
	mut t := TargetInstruction{}
	if r.bool()! {
		t.target_center_offset = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	t.actor_unique_id = types_662.ActorUniqueID.decode(mut r)!
	return t
}

pub struct CameraInstruction {
pub mut:
	set    ?SetInstruction
	clear  ?bool
	fade   ?FadeInstruction
	target ?TargetInstruction
}

pub fn (t CameraInstruction) encode(mut w serializer.Writer) {
	if v := t.set {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.clear {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := t.fade {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.target {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn CameraInstruction.decode(mut r serializer.Reader) !CameraInstruction {
	mut t := CameraInstruction{}
	if r.bool()! {
		t.set = SetInstruction.decode(mut r)!
	}
	if r.bool()! {
		t.clear = r.bool()!
	}
	if r.bool()! {
		t.fade = FadeInstruction.decode(mut r)!
	}
	if r.bool()! {
		t.target = TargetInstruction.decode(mut r)!
	}
	return t
}
