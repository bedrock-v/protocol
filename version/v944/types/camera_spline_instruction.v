module types

import protocol.serializer
import protocol.version.v859.enums as enums_859
import protocol.version.v924.enums as enums_924

pub struct ProgressKeyFrame {
pub mut:
	value     f32
	time      f32
	ease_type enums_924.CameraSplineEaseType
}

pub fn (t ProgressKeyFrame) encode(mut w serializer.Writer) {
	w.le_f32(t.value)
	w.le_f32(t.time)
	t.ease_type.encode(mut w)
}

pub fn ProgressKeyFrame.decode(mut r serializer.Reader) !ProgressKeyFrame {
	return ProgressKeyFrame{
		value:     r.le_f32()!
		time:      r.le_f32()!
		ease_type: enums_924.CameraSplineEaseType.decode(mut r)!
	}
}

pub struct RotationOption {
pub mut:
	key_frame_values [3]f32
	key_frame_times  f32
	ease_type        enums_924.CameraSplineEaseType
}

pub fn (t RotationOption) encode(mut w serializer.Writer) {
	w.le_f32(t.key_frame_values[0])
	w.le_f32(t.key_frame_values[1])
	w.le_f32(t.key_frame_values[2])
	w.le_f32(t.key_frame_times)
	t.ease_type.encode(mut w)
}

pub fn RotationOption.decode(mut r serializer.Reader) !RotationOption {
	return RotationOption{
		key_frame_values: [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		key_frame_times:  r.le_f32()!
		ease_type:        enums_924.CameraSplineEaseType.decode(mut r)!
	}
}

pub struct CameraSplineInstruction {
pub mut:
	total_time          f32
	spline_type         ?enums_859.CameraSplineType
	curve               [][3]f32
	progress_key_frames []ProgressKeyFrame
	rotation_option     []RotationOption
	spline_identifier   ?string
	load_from_json      ?bool
}

pub fn (t CameraSplineInstruction) encode(mut w serializer.Writer) {
	w.le_f32(t.total_time)
	if v := t.spline_type {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
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
	if v := t.spline_identifier {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	if v := t.load_from_json {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraSplineInstruction.decode(mut r serializer.Reader) !CameraSplineInstruction {
	mut t := CameraSplineInstruction{}
	t.total_time = r.le_f32()!
	if r.bool()! {
		t.spline_type = enums_859.CameraSplineType.decode(mut r)!
	}
	curve_count := r.read_count()!
	t.curve = [][3]f32{cap: serializer.prealloc(curve_count)}
	for _ in 0 .. curve_count {
		t.curve << [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	frame_count := r.read_count()!
	t.progress_key_frames = []ProgressKeyFrame{cap: serializer.prealloc(frame_count)}
	for _ in 0 .. frame_count {
		t.progress_key_frames << ProgressKeyFrame.decode(mut r)!
	}
	rotation_count := r.read_count()!
	t.rotation_option = []RotationOption{cap: serializer.prealloc(rotation_count)}
	for _ in 0 .. rotation_count {
		t.rotation_option << RotationOption.decode(mut r)!
	}
	if r.bool()! {
		t.spline_identifier = r.read_string()!
	}
	if r.bool()! {
		t.load_from_json = r.bool()!
	}
	return t
}
