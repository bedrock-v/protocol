module types

import protocol.serializer
import protocol.version.v662.types as types_662
import protocol.version.v662.enums as enums_662
import protocol.version.v859.enums

pub struct EaseData {
pub mut:
	ease_type enums_662.EasingType
	ease_time f32
}

pub fn (t EaseData) encode(mut w serializer.Writer) {
	t.ease_type.encode(mut w)
	w.le_f32(t.ease_time)
}

pub fn EaseData.decode(mut r serializer.Reader) !EaseData {
	return EaseData{
		ease_type: enums_662.EasingType.decode(mut r)!
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

pub struct FieldOfViewInstruction {
pub mut:
	field_of_view f32
	ease_time     f32
	ease_type     enums_662.EasingType
	clear         bool
}

pub fn (t FieldOfViewInstruction) encode(mut w serializer.Writer) {
	w.le_f32(t.field_of_view)
	w.le_f32(t.ease_time)
	t.ease_type.encode(mut w)
	w.bool(t.clear)
}

pub fn FieldOfViewInstruction.decode(mut r serializer.Reader) !FieldOfViewInstruction {
	return FieldOfViewInstruction{
		field_of_view: r.le_f32()!
		ease_time:     r.le_f32()!
		ease_type:     enums_662.EasingType.decode(mut r)!
		clear:         r.bool()!
	}
}

pub struct ProgressKeyFrame {
pub mut:
	value f32
	time  f32
}

pub fn (t ProgressKeyFrame) encode(mut w serializer.Writer) {
	w.le_f32(t.value)
	w.le_f32(t.time)
}

pub fn ProgressKeyFrame.decode(mut r serializer.Reader) !ProgressKeyFrame {
	return ProgressKeyFrame{
		value: r.le_f32()!
		time:  r.le_f32()!
	}
}

pub struct RotationOption {
pub mut:
	key_frame_values [3]f32
	key_frame_times  f32
}

pub fn (t RotationOption) encode(mut w serializer.Writer) {
	w.le_f32(t.key_frame_values[0])
	w.le_f32(t.key_frame_values[1])
	w.le_f32(t.key_frame_values[2])
	w.le_f32(t.key_frame_times)
}

pub fn RotationOption.decode(mut r serializer.Reader) !RotationOption {
	return RotationOption{
		key_frame_values: [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		key_frame_times:  r.le_f32()!
	}
}

pub struct SplineInstruction {
pub mut:
	total_time          f32
	spline_type         enums.CameraSplineType
	curve               [][3]f32
	progress_key_frames []ProgressKeyFrame
	rotation_option     []RotationOption
}

pub fn (t SplineInstruction) encode(mut w serializer.Writer) {
	w.le_f32(t.total_time)
	t.spline_type.encode(mut w)
	w.write_varuint32(u32(t.curve.len))
	for e in t.curve {
		w.le_f32(e[0])
		w.le_f32(e[1])
		w.le_f32(e[2])
	}
	w.write_varuint32(u32(t.progress_key_frames.len))
	for e in t.progress_key_frames {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.rotation_option.len))
	for e in t.rotation_option {
		e.encode(mut w)
	}
}

pub fn SplineInstruction.decode(mut r serializer.Reader) !SplineInstruction {
	mut t := SplineInstruction{}
	t.total_time = r.le_f32()!
	t.spline_type = enums.CameraSplineType.decode(mut r)!
	curve_count := r.read_count()!
	mut curve := [][3]f32{cap: serializer.prealloc(curve_count)}
	for _ in 0 .. curve_count {
		curve << [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	t.curve = curve
	frame_count := r.read_count()!
	mut progress_key_frames := []ProgressKeyFrame{cap: serializer.prealloc(frame_count)}
	for _ in 0 .. frame_count {
		progress_key_frames << ProgressKeyFrame.decode(mut r)!
	}
	t.progress_key_frames = progress_key_frames
	rotation_count := r.read_count()!
	mut rotation_option := []RotationOption{cap: serializer.prealloc(rotation_count)}
	for _ in 0 .. rotation_count {
		rotation_option << RotationOption.decode(mut r)!
	}
	t.rotation_option = rotation_option
	return t
}

pub struct AttachInstruction {
pub mut:
	actor_unique_id u64
}

pub fn (t AttachInstruction) encode(mut w serializer.Writer) {
	w.le_u64(t.actor_unique_id)
}

pub fn AttachInstruction.decode(mut r serializer.Reader) !AttachInstruction {
	return AttachInstruction{
		actor_unique_id: r.le_u64()!
	}
}

pub struct CameraInstruction {
pub mut:
	set           ?SetInstruction
	clear         ?bool
	fade          ?FadeInstruction
	target        ?TargetInstruction
	field_of_view ?FieldOfViewInstruction
	spline        ?SplineInstruction
	attach        ?AttachInstruction
	detach        ?bool
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
	if v := t.field_of_view {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.spline {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.attach {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.detach {
		w.bool(true)
		w.bool(v)
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
	if r.bool()! {
		t.field_of_view = FieldOfViewInstruction.decode(mut r)!
	}
	if r.bool()! {
		t.spline = SplineInstruction.decode(mut r)!
	}
	if r.bool()! {
		t.attach = AttachInstruction.decode(mut r)!
	}
	if r.bool()! {
		t.detach = r.bool()!
	}
	return t
}
