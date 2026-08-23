module types

import protocol.serializer
import protocol.version.v924.enums
import protocol.version.v859.enums as enums_859

pub struct ProgressKeyFrame {
pub mut:
	value     f32
	time      f32
	ease_type enums.CameraSplineEaseType
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
		ease_type: enums.CameraSplineEaseType.decode(mut r)!
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

pub struct CameraSplineInstruction {
pub mut:
	total_time          f32
	spline_type         enums_859.CameraSplineType
	curve               [][3]f32
	progress_key_frames []ProgressKeyFrame
	rotation_option     []RotationOption
}

pub fn (t CameraSplineInstruction) encode(mut w serializer.Writer) {
	w.le_f32(t.total_time)
	t.spline_type.encode(mut w)
	w.write_varuint32(u32(t.curve.len))
	for point in t.curve {
		w.le_f32(point[0])
		w.le_f32(point[1])
		w.le_f32(point[2])
	}
	w.write_varuint32(u32(t.progress_key_frames.len))
	for frame in t.progress_key_frames {
		frame.encode(mut w)
	}
	w.write_varuint32(u32(t.rotation_option.len))
	for option in t.rotation_option {
		option.encode(mut w)
	}
}

pub fn CameraSplineInstruction.decode(mut r serializer.Reader) !CameraSplineInstruction {
	mut t := CameraSplineInstruction{}
	t.total_time = r.le_f32()!
	t.spline_type = enums_859.CameraSplineType.decode(mut r)!
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
	option_count := r.read_count()!
	t.rotation_option = []RotationOption{cap: serializer.prealloc(option_count)}
	for _ in 0 .. option_count {
		t.rotation_option << RotationOption.decode(mut r)!
	}
	return t
}
