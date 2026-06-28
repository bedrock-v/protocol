module protocol

import serializer
import types

pub struct CameraSetInstructionEase {
pub mut:
	type     u8
	duration f32
}

pub struct CameraSetInstructionRotation {
pub mut:
	pitch f32
	yaw   f32
}

pub struct CameraSetInstruction {
pub mut:
	preset                 u32
	ease                   ?CameraSetInstructionEase
	camera_position        ?types.Vector3
	rotation               ?CameraSetInstructionRotation
	facing_position        ?types.Vector3
	view_offset            ?types.Vector2
	entity_offset          ?types.Vector3
	default                ?bool
	ignore_starting_values bool
}

pub struct CameraFadeInstructionTime {
pub mut:
	fade_in  f32
	stay     f32
	fade_out f32
}

pub struct CameraFadeInstructionColor {
pub mut:
	red   f32
	green f32
	blue  f32
}

pub struct CameraFadeInstruction {
pub mut:
	time  ?CameraFadeInstructionTime
	color ?CameraFadeInstructionColor
}

pub struct CameraTargetInstruction {
pub mut:
	target_center_offset ?types.Vector3
	actor_unique_id      i64
}

pub struct CameraFovInstruction {
pub mut:
	field_of_view f32
	ease_time     f32
	ease_type     string
	clear         bool
}

pub struct CameraInstructionPacket {
pub mut:
	set                ?CameraSetInstruction
	clear              ?bool
	fade               ?CameraFadeInstruction
	target             ?CameraTargetInstruction
	remove_target      ?bool
	field_of_view      ?CameraFovInstruction
	spline             ?CameraSplineInstruction
	attach_to_entity   ?i64
	detach_from_entity ?bool
}

pub fn (p &CameraInstructionPacket) pid() u16 {
	return camera_instruction_packet
}

pub fn (p &CameraInstructionPacket) name() string {
	return 'CameraInstructionPacket'
}

pub fn (p &CameraInstructionPacket) can_be_sent_before_login() bool {
	return false
}

fn read_camera_set(mut r serializer.Reader) !CameraSetInstruction {
	mut s := CameraSetInstruction{
		preset: r.le_u32()!
	}
	if r.bool()! {
		s.ease = CameraSetInstructionEase{
			type:     r.u8()!
			duration: r.le_f32()!
		}
	}
	if r.bool()! {
		s.camera_position = r.read_vector3()!
	}
	if r.bool()! {
		s.rotation = CameraSetInstructionRotation{
			pitch: r.le_f32()!
			yaw:   r.le_f32()!
		}
	}
	if r.bool()! {
		s.facing_position = r.read_vector3()!
	}
	if r.bool()! {
		s.view_offset = r.read_vector2()!
	}
	if r.bool()! {
		s.entity_offset = r.read_vector3()!
	}
	if r.bool()! {
		s.default = r.bool()!
	}
	s.ignore_starting_values = r.bool()!
	return s
}

fn write_camera_set(mut w serializer.Writer, s CameraSetInstruction) {
	w.le_u32(s.preset)
	if e := s.ease {
		w.bool(true)
		w.u8(e.type)
		w.le_f32(e.duration)
	} else {
		w.bool(false)
	}
	if v := s.camera_position {
		w.bool(true)
		w.write_vector3(v)
	} else {
		w.bool(false)
	}
	if rot := s.rotation {
		w.bool(true)
		w.le_f32(rot.pitch)
		w.le_f32(rot.yaw)
	} else {
		w.bool(false)
	}
	if v := s.facing_position {
		w.bool(true)
		w.write_vector3(v)
	} else {
		w.bool(false)
	}
	if v := s.view_offset {
		w.bool(true)
		w.write_vector2(v)
	} else {
		w.bool(false)
	}
	if v := s.entity_offset {
		w.bool(true)
		w.write_vector3(v)
	} else {
		w.bool(false)
	}
	if d := s.default {
		w.bool(true)
		w.bool(d)
	} else {
		w.bool(false)
	}
	w.bool(s.ignore_starting_values)
}

fn read_camera_fade(mut r serializer.Reader) !CameraFadeInstruction {
	mut f := CameraFadeInstruction{}
	if r.bool()! {
		f.time = CameraFadeInstructionTime{
			fade_in:  r.le_f32()!
			stay:     r.le_f32()!
			fade_out: r.le_f32()!
		}
	}
	if r.bool()! {
		f.color = CameraFadeInstructionColor{
			red:   r.le_f32()!
			green: r.le_f32()!
			blue:  r.le_f32()!
		}
	}
	return f
}

fn write_camera_fade(mut w serializer.Writer, f CameraFadeInstruction) {
	if t := f.time {
		w.bool(true)
		w.le_f32(t.fade_in)
		w.le_f32(t.stay)
		w.le_f32(t.fade_out)
	} else {
		w.bool(false)
	}
	if c := f.color {
		w.bool(true)
		w.le_f32(c.red)
		w.le_f32(c.green)
		w.le_f32(c.blue)
	} else {
		w.bool(false)
	}
}

pub fn (mut p CameraInstructionPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.set = read_camera_set(mut r)!
	}
	if r.bool()! {
		p.clear = r.bool()!
	}
	if r.bool()! {
		p.fade = read_camera_fade(mut r)!
	}
	if r.bool()! {
		mut t := CameraTargetInstruction{}
		if r.bool()! {
			t.target_center_offset = r.read_vector3()!
		}
		t.actor_unique_id = i64(r.le_u64()!)
		p.target = t
	}
	if r.bool()! {
		p.remove_target = r.bool()!
	}
	if r.bool()! {
		p.field_of_view = CameraFovInstruction{
			field_of_view: r.le_f32()!
			ease_time:     r.le_f32()!
			ease_type:     r.read_string()!
			clear:         r.bool()!
		}
	}
	if r.bool()! {
		p.spline = read_camera_spline_instruction(mut r)!
	}
	if r.bool()! {
		p.attach_to_entity = i64(r.le_u64()!)
	}
	if r.bool()! {
		p.detach_from_entity = r.bool()!
	}
}

pub fn (p &CameraInstructionPacket) encode_payload(mut w serializer.Writer) {
	if s := p.set {
		w.bool(true)
		write_camera_set(mut w, s)
	} else {
		w.bool(false)
	}
	if c := p.clear {
		w.bool(true)
		w.bool(c)
	} else {
		w.bool(false)
	}
	if f := p.fade {
		w.bool(true)
		write_camera_fade(mut w, f)
	} else {
		w.bool(false)
	}
	if t := p.target {
		w.bool(true)
		if v := t.target_center_offset {
			w.bool(true)
			w.write_vector3(v)
		} else {
			w.bool(false)
		}
		w.le_u64(u64(t.actor_unique_id))
	} else {
		w.bool(false)
	}
	if rt := p.remove_target {
		w.bool(true)
		w.bool(rt)
	} else {
		w.bool(false)
	}
	if fov := p.field_of_view {
		w.bool(true)
		w.le_f32(fov.field_of_view)
		w.le_f32(fov.ease_time)
		w.write_string(fov.ease_type)
		w.bool(fov.clear)
	} else {
		w.bool(false)
	}
	if sp := p.spline {
		w.bool(true)
		write_camera_spline_instruction(mut w, sp)
	} else {
		w.bool(false)
	}
	if a := p.attach_to_entity {
		w.bool(true)
		w.le_u64(u64(a))
	} else {
		w.bool(false)
	}
	if d := p.detach_from_entity {
		w.bool(true)
		w.bool(d)
	} else {
		w.bool(false)
	}
}
