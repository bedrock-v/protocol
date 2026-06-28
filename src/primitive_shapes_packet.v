module protocol

import serializer
import types

pub const primitive_shape_payload_none = u32(0)
pub const primitive_shape_payload_arrow = u32(1)
pub const primitive_shape_payload_text = u32(2)
pub const primitive_shape_payload_box = u32(3)
pub const primitive_shape_payload_line = u32(4)
pub const primitive_shape_payload_circle_or_sphere = u32(5)
pub const primitive_shape_payload_cylinder = u32(6)
pub const primitive_shape_payload_pyramid = u32(7)
pub const primitive_shape_payload_ellipsoid = u32(8)
pub const primitive_shape_payload_cone = u32(9)

pub struct PacketShapeData {
pub mut:
	network_id              u64
	has_type                bool
	shape_type              u8
	has_location            bool
	location                types.Vector3
	has_scale               bool
	scale                   f32
	has_rotation            bool
	rotation                types.Vector3
	has_total_time_left     bool
	total_time_left         f32
	has_max_render_distance bool
	max_render_distance     f32
	has_color               bool
	color                   u32
	has_dimension_id        bool
	dimension_id            int
	has_attached_entity     bool
	attached_entity_id      u64
	payload_type            u32

	arrow_has_end       bool
	arrow_end           types.Vector3
	arrow_has_head_len  bool
	arrow_head_len      f32
	arrow_has_head_rad  bool
	arrow_head_rad      f32
	arrow_has_segments  bool
	arrow_segments      u8

	text                string
	use_rotation        bool
	has_bg_color        bool
	bg_color            u32
	depth_test          bool
	show_backface       bool
	show_text_backface  bool

	box_bound       types.Vector3
	line_end        types.Vector3
	segments        u8

	cyl_radius_x    types.Vector2
	cyl_radius_z    types.Vector2
	cyl_height      f32
	cyl_segments    u8

	pyramid_width      f32
	pyramid_has_depth  bool
	pyramid_depth      f32
	pyramid_height     f32

	ellipsoid_radii            types.Vector3
	ellipsoid_segments_per_axis u8

	cone_radii    types.Vector2
	cone_height   f32
	cone_segments u8
}

pub struct PrimitiveShapesPacket {
pub mut:
	shapes []PacketShapeData
}

pub fn (p &PrimitiveShapesPacket) pid() u16 {
	return primitive_shapes_packet
}

pub fn (p &PrimitiveShapesPacket) name() string {
	return 'PrimitiveShapesPacket'
}

pub fn (p &PrimitiveShapesPacket) can_be_sent_before_login() bool {
	return false
}

fn read_packet_shape_data(mut r serializer.Reader) !PacketShapeData {
	mut s := PacketShapeData{
		network_id: r.read_varuint64()!
	}
	if r.bool()! {
		s.has_type = true
		s.shape_type = r.u8()!
	}
	if r.bool()! {
		s.has_location = true
		s.location = r.read_vector3()!
	}
	if r.bool()! {
		s.has_scale = true
		s.scale = r.le_f32()!
	}
	if r.bool()! {
		s.has_rotation = true
		s.rotation = r.read_vector3()!
	}
	if r.bool()! {
		s.has_total_time_left = true
		s.total_time_left = r.le_f32()!
	}
	if r.bool()! {
		s.has_max_render_distance = true
		s.max_render_distance = r.le_f32()!
	}
	if r.bool()! {
		s.has_color = true
		s.color = r.le_u32()!
	}
	if r.bool()! {
		s.has_dimension_id = true
		s.dimension_id = r.read_varint32()!
	}
	if r.bool()! {
		s.has_attached_entity = true
		s.attached_entity_id = r.read_actor_runtime_id()!
	}
	s.payload_type = r.read_varuint32()!
	match s.payload_type {
		primitive_shape_payload_arrow {
			if r.bool()! {
				s.arrow_has_end = true
				s.arrow_end = r.read_vector3()!
			}
			if r.bool()! {
				s.arrow_has_head_len = true
				s.arrow_head_len = r.le_f32()!
			}
			if r.bool()! {
				s.arrow_has_head_rad = true
				s.arrow_head_rad = r.le_f32()!
			}
			if r.bool()! {
				s.arrow_has_segments = true
				s.arrow_segments = r.u8()!
			}
		}
		primitive_shape_payload_text {
			s.text = r.read_string()!
			s.use_rotation = r.bool()!
			if r.bool()! {
				s.has_bg_color = true
				s.bg_color = r.le_u32()!
			}
			s.depth_test = r.bool()!
			s.show_backface = r.bool()!
			s.show_text_backface = r.bool()!
		}
		primitive_shape_payload_box {
			s.box_bound = r.read_vector3()!
		}
		primitive_shape_payload_line {
			s.line_end = r.read_vector3()!
		}
		primitive_shape_payload_circle_or_sphere {
			s.segments = r.u8()!
		}
		primitive_shape_payload_cylinder {
			s.cyl_radius_x = r.read_vector2()!
			s.cyl_radius_z = r.read_vector2()!
			s.cyl_height = r.le_f32()!
			s.cyl_segments = r.u8()!
		}
		primitive_shape_payload_pyramid {
			s.pyramid_width = r.le_f32()!
			if r.bool()! {
				s.pyramid_has_depth = true
				s.pyramid_depth = r.le_f32()!
			}
			s.pyramid_height = r.le_f32()!
		}
		primitive_shape_payload_ellipsoid {
			s.ellipsoid_radii = r.read_vector3()!
			s.ellipsoid_segments_per_axis = r.u8()!
		}
		primitive_shape_payload_cone {
			s.cone_radii = r.read_vector2()!
			s.cone_height = r.le_f32()!
			s.cone_segments = r.u8()!
		}
		else {}
	}
	return s
}

fn write_packet_shape_data(mut w serializer.Writer, s PacketShapeData) {
	w.write_varuint64(s.network_id)
	if s.has_type {
		w.bool(true)
		w.u8(s.shape_type)
	} else {
		w.bool(false)
	}
	if s.has_location {
		w.bool(true)
		w.write_vector3(s.location)
	} else {
		w.bool(false)
	}
	if s.has_scale {
		w.bool(true)
		w.le_f32(s.scale)
	} else {
		w.bool(false)
	}
	if s.has_rotation {
		w.bool(true)
		w.write_vector3(s.rotation)
	} else {
		w.bool(false)
	}
	if s.has_total_time_left {
		w.bool(true)
		w.le_f32(s.total_time_left)
	} else {
		w.bool(false)
	}
	if s.has_max_render_distance {
		w.bool(true)
		w.le_f32(s.max_render_distance)
	} else {
		w.bool(false)
	}
	if s.has_color {
		w.bool(true)
		w.le_u32(s.color)
	} else {
		w.bool(false)
	}
	if s.has_dimension_id {
		w.bool(true)
		w.write_varint32(s.dimension_id)
	} else {
		w.bool(false)
	}
	if s.has_attached_entity {
		w.bool(true)
		w.write_actor_runtime_id(s.attached_entity_id)
	} else {
		w.bool(false)
	}
	w.write_varuint32(s.payload_type)
	match s.payload_type {
		primitive_shape_payload_arrow {
			if s.arrow_has_end {
				w.bool(true)
				w.write_vector3(s.arrow_end)
			} else {
				w.bool(false)
			}
			if s.arrow_has_head_len {
				w.bool(true)
				w.le_f32(s.arrow_head_len)
			} else {
				w.bool(false)
			}
			if s.arrow_has_head_rad {
				w.bool(true)
				w.le_f32(s.arrow_head_rad)
			} else {
				w.bool(false)
			}
			if s.arrow_has_segments {
				w.bool(true)
				w.u8(s.arrow_segments)
			} else {
				w.bool(false)
			}
		}
		primitive_shape_payload_text {
			w.write_string(s.text)
			w.bool(s.use_rotation)
			if s.has_bg_color {
				w.bool(true)
				w.le_u32(s.bg_color)
			} else {
				w.bool(false)
			}
			w.bool(s.depth_test)
			w.bool(s.show_backface)
			w.bool(s.show_text_backface)
		}
		primitive_shape_payload_box {
			w.write_vector3(s.box_bound)
		}
		primitive_shape_payload_line {
			w.write_vector3(s.line_end)
		}
		primitive_shape_payload_circle_or_sphere {
			w.u8(s.segments)
		}
		primitive_shape_payload_cylinder {
			w.write_vector2(s.cyl_radius_x)
			w.write_vector2(s.cyl_radius_z)
			w.le_f32(s.cyl_height)
			w.u8(s.cyl_segments)
		}
		primitive_shape_payload_pyramid {
			w.le_f32(s.pyramid_width)
			if s.pyramid_has_depth {
				w.bool(true)
				w.le_f32(s.pyramid_depth)
			} else {
				w.bool(false)
			}
			w.le_f32(s.pyramid_height)
		}
		primitive_shape_payload_ellipsoid {
			w.write_vector3(s.ellipsoid_radii)
			w.u8(s.ellipsoid_segments_per_axis)
		}
		primitive_shape_payload_cone {
			w.write_vector2(s.cone_radii)
			w.le_f32(s.cone_height)
			w.u8(s.cone_segments)
		}
		else {}
	}
}

pub fn (mut p PrimitiveShapesPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.shapes = []PacketShapeData{}
	for _ in 0 .. count {
		p.shapes << read_packet_shape_data(mut r)!
	}
}

pub fn (p &PrimitiveShapesPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shapes.len))
	for s in p.shapes {
		write_packet_shape_data(mut w, s)
	}
}
