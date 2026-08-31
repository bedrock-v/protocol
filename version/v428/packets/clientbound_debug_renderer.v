module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub enum DebugRendererType as u32 {
	invalid               = 0
	clear_debug_markers   = 1
	add_debug_marker_cube = 2
}

pub struct ClientboundDebugRendererPacket {
pub mut:
	debug_marker_type  DebugRendererType
	marker_text        string
	marker_position    types_291.Vector3f
	marker_color_red   f32
	marker_color_green f32
	marker_color_blue  f32
	marker_color_alpha f32
	marker_duration    i64
}

pub fn (p &ClientboundDebugRendererPacket) pid() u16 {
	return 164
}

pub fn (p &ClientboundDebugRendererPacket) name() string {
	return 'ClientboundDebugRendererPacket'
}

pub fn (p &ClientboundDebugRendererPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientboundDebugRendererPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.debug_marker_type))
	if p.debug_marker_type == .add_debug_marker_cube {
		w.write_string(p.marker_text)
		p.marker_position.encode(mut w)
		w.be_f32(p.marker_color_red)
		w.be_f32(p.marker_color_green)
		w.be_f32(p.marker_color_blue)
		w.be_f32(p.marker_color_alpha)
		w.le_i64(p.marker_duration)
	}
}

pub fn (mut p ClientboundDebugRendererPacket) decode_payload(mut r serializer.Reader) ! {
	p.debug_marker_type = unsafe { DebugRendererType(r.read_varuint32()!) }
	if p.debug_marker_type == .add_debug_marker_cube {
		p.marker_text = r.read_string()!
		p.marker_position = types_291.Vector3f.decode(mut r)!
		p.marker_color_red = r.be_f32()!
		p.marker_color_green = r.be_f32()!
		p.marker_color_blue = r.be_f32()!
		p.marker_color_alpha = r.be_f32()!
		p.marker_duration = r.le_i64()!
	}
}
