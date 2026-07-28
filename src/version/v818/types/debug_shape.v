module types

import protocol.serializer
import protocol.version.v800.types as types_800

pub enum DebugShapeType as i8 {
	line   = 0
	box    = 1
	sphere = 2
	circle = 3
	text   = 4
	arrow  = 5
}

pub fn (e DebugShapeType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn DebugShapeType.decode(mut r serializer.Reader) !DebugShapeType {
	return unsafe { DebugShapeType(r.i8()!) }
}

pub struct DebugShape {
pub mut:
	id                 u64
	debug_shape_type   ?DebugShapeType
	position           ?[3]f32
	scale              ?f32
	rotation           ?[2]f32
	remaining_duration ?f32
	color              ?types_800.Color
	text               ?string
	box_bounds         ?[3]f32
	line_end_position  ?[3]f32
	arrow_head_length  ?f32
	arrow_head_radius  ?f32
	segments           ?i8
}

pub fn (t DebugShape) encode(mut w serializer.Writer) {
	w.write_varuint64(t.id)
	if v := t.debug_shape_type {
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
	if v := t.scale {
		w.bool(true)
		w.le_f32(v)
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
	if v := t.remaining_duration {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
	if v := t.color {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := t.text {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	if v := t.box_bounds {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
	if v := t.line_end_position {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
	if v := t.arrow_head_length {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
	if v := t.arrow_head_radius {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
	if v := t.segments {
		w.bool(true)
		w.i8(v)
	} else {
		w.bool(false)
	}
}

pub fn DebugShape.decode(mut r serializer.Reader) !DebugShape {
	mut t := DebugShape{}
	t.id = r.read_varuint64()!
	if r.bool()! {
		t.debug_shape_type = DebugShapeType.decode(mut r)!
	}
	if r.bool()! {
		t.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.scale = r.le_f32()!
	}
	if r.bool()! {
		t.rotation = [r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.remaining_duration = r.le_f32()!
	}
	if r.bool()! {
		t.color = types_800.Color.decode(mut r)!
	}
	if r.bool()! {
		t.text = r.read_string()!
	}
	if r.bool()! {
		t.box_bounds = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.line_end_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	if r.bool()! {
		t.arrow_head_length = r.le_f32()!
	}
	if r.bool()! {
		t.arrow_head_radius = r.le_f32()!
	}
	if r.bool()! {
		t.segments = r.i8()!
	}
	return t
}
