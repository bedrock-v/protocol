module src

import src.serializer
import src.types

pub struct CameraProgressOption {
pub mut:
	value     f32
	time      f32
	ease_type string
}

pub struct CameraRotationOption {
pub mut:
	value types.Vector3
	time  f32
	ease  string
}

pub struct CameraSplineInstruction {
pub mut:
	total_time          f32
	ease_type           u8
	curve               []types.Vector3
	progress_key_frames []CameraProgressOption
	rotation_options    []CameraRotationOption
	spline_identifier   string
	load_from_json      bool
}

pub struct CameraSplineDefinition {
pub mut:
	name        string
	instruction CameraSplineInstruction
}

pub struct CameraSplinePacket {
pub mut:
	splines []CameraSplineDefinition
}

pub fn (p &CameraSplinePacket) pid() u16 {
	return camera_spline_packet
}

pub fn (p &CameraSplinePacket) name() string {
	return 'CameraSplinePacket'
}

pub fn (p &CameraSplinePacket) can_be_sent_before_login() bool {
	return false
}

fn read_camera_spline_instruction(mut r serializer.Reader) !CameraSplineInstruction {
	mut ins := CameraSplineInstruction{
		total_time: r.le_f32()!
		ease_type:  r.u8()!
	}
	curve_count := r.read_varuint32()!
	ins.curve = []types.Vector3{}
	for _ in 0 .. curve_count {
		ins.curve << r.read_vector3()!
	}
	progress_count := r.read_varuint32()!
	ins.progress_key_frames = []CameraProgressOption{}
	for _ in 0 .. progress_count {
		ins.progress_key_frames << CameraProgressOption{
			value:     r.le_f32()!
			time:      r.le_f32()!
			ease_type: r.read_string()!
		}
	}
	rotation_count := r.read_varuint32()!
	ins.rotation_options = []CameraRotationOption{}
	for _ in 0 .. rotation_count {
		ins.rotation_options << CameraRotationOption{
			value: r.read_vector3()!
			time:  r.le_f32()!
			ease:  r.read_string()!
		}
	}
	ins.spline_identifier = r.read_string()!
	ins.load_from_json = r.bool()!
	return ins
}

fn write_camera_spline_instruction(mut w serializer.Writer, ins CameraSplineInstruction) {
	w.le_f32(ins.total_time)
	w.u8(ins.ease_type)
	w.write_varuint32(u32(ins.curve.len))
	for v in ins.curve {
		w.write_vector3(v)
	}
	w.write_varuint32(u32(ins.progress_key_frames.len))
	for pk in ins.progress_key_frames {
		w.le_f32(pk.value)
		w.le_f32(pk.time)
		w.write_string(pk.ease_type)
	}
	w.write_varuint32(u32(ins.rotation_options.len))
	for ro in ins.rotation_options {
		w.write_vector3(ro.value)
		w.le_f32(ro.time)
		w.write_string(ro.ease)
	}
	w.write_string(ins.spline_identifier)
	w.bool(ins.load_from_json)
}

pub fn (mut p CameraSplinePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.splines = []CameraSplineDefinition{}
	for _ in 0 .. count {
		p.splines << CameraSplineDefinition{
			name:        r.read_string()!
			instruction: read_camera_spline_instruction(mut r)!
		}
	}
}

pub fn (p &CameraSplinePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.splines.len))
	for s in p.splines {
		w.write_string(s.name)
		write_camera_spline_instruction(mut w, s.instruction)
	}
}
