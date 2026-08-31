module types

import protocol.serializer
import protocol.version.v800.types as types_800

pub struct DebugShape {
pub mut:
	id                      u64
	debug_shape_type        ?DebugShapeType
	position                ?[3]f32
	scale                   ?f32
	rotation                ?[2]f32
	remaining_duration      ?f32
	maximum_render_distance ?f32
	color                   ?types_800.Color
	dimension               ?i32
	attached_to_entity_id   ?u64
	shape_data              DebugShapeData = DebugShapeLast{}
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
	if v := t.maximum_render_distance {
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
	if v := t.dimension {
		w.bool(true)
		w.write_varint32(v)
	} else {
		w.bool(false)
	}
	if v := t.attached_to_entity_id {
		w.bool(true)
		w.write_varuint64(v)
	} else {
		w.bool(false)
	}
	t.shape_data.encode(mut w)
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
		t.maximum_render_distance = r.le_f32()!
	}
	if r.bool()! {
		t.color = types_800.Color.decode(mut r)!
	}
	if r.bool()! {
		t.dimension = r.read_varint32()!
	}
	if r.bool()! {
		t.attached_to_entity_id = r.read_varuint64()!
	}
	t.shape_data = DebugShapeData.decode(mut r)!
	return t
}

pub enum DebugShapeType as i8 {
	line      = 0
	box       = 1
	sphere    = 2
	circle    = 3
	text      = 4
	arrow     = 5
	cylinder  = 6
	pyramid   = 7
	ellipsoid = 8
	cone      = 9
}

pub fn (e DebugShapeType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn DebugShapeType.decode(mut r serializer.Reader) !DebugShapeType {
	return unsafe { DebugShapeType(r.i8()!) }
}

pub struct DebugShapeLast {}

pub struct DebugShapeArrow {
pub mut:
	arrow_end_position  ?[3]f32
	arrow_head_length   ?f32
	arrow_head_radius   ?f32
	arrow_head_segments ?i8
}

pub struct DebugShapeText {
pub mut:
	text               ?string
	use_rotation       bool
	background_color   ?i32
	depth_test         bool
	show_backface      bool
	show_text_backface bool
}

pub struct DebugShapeBox {
pub mut:
	box_bounds ?[3]f32
}

pub struct DebugShapeLine {
pub mut:
	line_end_position ?[3]f32
}

pub struct DebugShapeSphere {
pub mut:
	segments ?i8
}

pub struct DebugShapeCylinder {
pub mut:
	radius_x [2]f32
	radius_z [2]f32
	height   f32
	segments u8
}

pub struct DebugShapePyramid {
pub mut:
	width  f32
	depth  ?f32
	height f32
}

pub struct DebugShapeEllipsoid {
pub mut:
	radii    [3]f32
	segments u8
}

pub struct DebugShapeCone {
pub mut:
	radii    [2]f32
	height   f32
	segments u8
}

pub type DebugShapeData = DebugShapeArrow
	| DebugShapeBox
	| DebugShapeCone
	| DebugShapeCylinder
	| DebugShapeEllipsoid
	| DebugShapeLast
	| DebugShapeLine
	| DebugShapePyramid
	| DebugShapeSphere
	| DebugShapeText

fn encode_opt_f32(mut w serializer.Writer, v ?f32) {
	if x := v {
		w.bool(true)
		w.le_f32(x)
	} else {
		w.bool(false)
	}
}

fn encode_opt_vec3(mut w serializer.Writer, v ?[3]f32) {
	if x := v {
		w.bool(true)
		w.le_f32(x[0])
		w.le_f32(x[1])
		w.le_f32(x[2])
	} else {
		w.bool(false)
	}
}

fn encode_opt_i8(mut w serializer.Writer, v ?i8) {
	if x := v {
		w.bool(true)
		w.i8(x)
	} else {
		w.bool(false)
	}
}

pub fn (t DebugShapeData) encode(mut w serializer.Writer) {
	match t {
		DebugShapeLast {
			w.write_varuint32(0)
		}
		DebugShapeArrow {
			w.write_varuint32(1)
			encode_opt_vec3(mut w, t.arrow_end_position)
			encode_opt_f32(mut w, t.arrow_head_length)
			encode_opt_f32(mut w, t.arrow_head_radius)
			encode_opt_i8(mut w, t.arrow_head_segments)
		}
		DebugShapeText {
			w.write_varuint32(2)
			if v := t.text {
				w.bool(true)
				w.write_string(v)
			} else {
				w.bool(false)
			}
			w.bool(t.use_rotation)
			if v := t.background_color {
				w.bool(true)
				w.le_i32(v)
			} else {
				w.bool(false)
			}
			w.bool(t.depth_test)
			w.bool(t.show_backface)
			w.bool(t.show_text_backface)
		}
		DebugShapeBox {
			w.write_varuint32(3)
			encode_opt_vec3(mut w, t.box_bounds)
		}
		DebugShapeLine {
			w.write_varuint32(4)
			encode_opt_vec3(mut w, t.line_end_position)
		}
		DebugShapeSphere {
			w.write_varuint32(5)
			encode_opt_i8(mut w, t.segments)
		}
		DebugShapeCylinder {
			w.write_varuint32(6)
			w.le_f32(t.radius_x[0])
			w.le_f32(t.radius_x[1])
			w.le_f32(t.radius_z[0])
			w.le_f32(t.radius_z[1])
			w.le_f32(t.height)
			w.u8(t.segments)
		}
		DebugShapePyramid {
			w.write_varuint32(7)
			w.le_f32(t.width)
			encode_opt_f32(mut w, t.depth)
			w.le_f32(t.height)
		}
		DebugShapeEllipsoid {
			w.write_varuint32(8)
			w.le_f32(t.radii[0])
			w.le_f32(t.radii[1])
			w.le_f32(t.radii[2])
			w.u8(t.segments)
		}
		DebugShapeCone {
			w.write_varuint32(9)
			w.le_f32(t.radii[0])
			w.le_f32(t.radii[1])
			w.le_f32(t.height)
			w.u8(t.segments)
		}
	}
}

pub fn DebugShapeData.decode(mut r serializer.Reader) !DebugShapeData {
	d := r.read_varuint32()!
	match d {
		0 {
			return DebugShapeLast{}
		}
		1 {
			mut t := DebugShapeArrow{}
			if r.bool()! {
				t.arrow_end_position = [r.le_f32()!, r.le_f32()!,
					r.le_f32()!]!
			}
			if r.bool()! {
				t.arrow_head_length = r.le_f32()!
			}
			if r.bool()! {
				t.arrow_head_radius = r.le_f32()!
			}
			if r.bool()! {
				t.arrow_head_segments = r.i8()!
			}
			return t
		}
		2 {
			mut t := DebugShapeText{}
			if r.bool()! {
				t.text = r.read_string()!
			}
			t.use_rotation = r.bool()!
			if r.bool()! {
				t.background_color = r.le_i32()!
			}
			t.depth_test = r.bool()!
			t.show_backface = r.bool()!
			t.show_text_backface = r.bool()!
			return t
		}
		3 {
			mut t := DebugShapeBox{}
			if r.bool()! {
				t.box_bounds = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
			}
			return t
		}
		4 {
			mut t := DebugShapeLine{}
			if r.bool()! {
				t.line_end_position = [r.le_f32()!, r.le_f32()!,
					r.le_f32()!]!
			}
			return t
		}
		5 {
			mut t := DebugShapeSphere{}
			if r.bool()! {
				t.segments = r.i8()!
			}
			return t
		}
		6 {
			return DebugShapeCylinder{
				radius_x: [r.le_f32()!, r.le_f32()!]!
				radius_z: [r.le_f32()!, r.le_f32()!]!
				height:   r.le_f32()!
				segments: r.u8()!
			}
		}
		7 {
			mut t := DebugShapePyramid{}
			t.width = r.le_f32()!
			if r.bool()! {
				t.depth = r.le_f32()!
			}
			t.height = r.le_f32()!
			return t
		}
		8 {
			return DebugShapeEllipsoid{
				radii:    [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
				segments: r.u8()!
			}
		}
		9 {
			return DebugShapeCone{
				radii:    [r.le_f32()!, r.le_f32()!]!
				height:   r.le_f32()!
				segments: r.u8()!
			}
		}
		else {
			return error('invalid DebugShapeData ${d}')
		}
	}
}
