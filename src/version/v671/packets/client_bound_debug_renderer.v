module packets

import serializer

pub struct DebugRendererInvalid {}

pub struct DebugRendererClearDebugMarkers {}

pub struct DebugRendererAddDebugMarkerCube {
pub mut:
	text                 string
	position             [3]f32
	r                    f32
	g                    f32
	b                    f32
	a                    f32
	millisecond_duration u64
}

pub type ClientBoundDebugRendererType = DebugRendererAddDebugMarkerCube
	| DebugRendererClearDebugMarkers
	| DebugRendererInvalid

pub fn (t ClientBoundDebugRendererType) encode(mut w serializer.Writer) {
	match t {
		DebugRendererInvalid { w.le_u32(0) }
		DebugRendererClearDebugMarkers { w.le_u32(1) }
		DebugRendererAddDebugMarkerCube {
			w.le_u32(2)
			w.write_string(t.text)
			w.le_f32(t.position[0])
			w.le_f32(t.position[1])
			w.le_f32(t.position[2])
			w.le_f32(t.r)
			w.le_f32(t.g)
			w.le_f32(t.b)
			w.le_f32(t.a)
			w.le_u64(t.millisecond_duration)
		}
	}
}

pub fn ClientBoundDebugRendererType.decode(mut r serializer.Reader) !ClientBoundDebugRendererType {
	d := r.le_u32()!
	match d {
		0 { return DebugRendererInvalid{} }
		1 { return DebugRendererClearDebugMarkers{} }
		2 {
			return DebugRendererAddDebugMarkerCube{
				text:                 r.read_string()!
				position:             [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
				r:                    r.le_f32()!
				g:                    r.le_f32()!
				b:                    r.le_f32()!
				a:                    r.le_f32()!
				millisecond_duration: r.le_u64()!
			}
		}
		else { return error('invalid ClientBoundDebugRendererType ${d}') }
	}
}

pub struct ClientBoundDebugRendererPacket {
pub mut:
	debug_marker_type ClientBoundDebugRendererType = DebugRendererInvalid{}
}

pub fn (p &ClientBoundDebugRendererPacket) pid() u16 { return 164 }

pub fn (p &ClientBoundDebugRendererPacket) name() string { return 'ClientBoundDebugRendererPacket' }

pub fn (p &ClientBoundDebugRendererPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ClientBoundDebugRendererPacket) encode_payload(mut w serializer.Writer) {
	p.debug_marker_type.encode(mut w)
}

pub fn (mut p ClientBoundDebugRendererPacket) decode_payload(mut r serializer.Reader) ! {
	p.debug_marker_type = ClientBoundDebugRendererType.decode(mut r)!
}
