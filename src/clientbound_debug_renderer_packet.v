module protocol

import serializer
import types

pub struct DebugMarkerData {
pub mut:
	text            string
	position        types.Vector3
	color           u32
	duration_millis u64
}

pub struct ClientboundDebugRendererPacket {
pub mut:
	type string
	data ?DebugMarkerData
}

pub fn (p &ClientboundDebugRendererPacket) pid() u16 {
	return clientbound_debug_renderer_packet
}

pub fn (p &ClientboundDebugRendererPacket) name() string {
	return 'ClientboundDebugRendererPacket'
}

pub fn (p &ClientboundDebugRendererPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundDebugRendererPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.read_string()!
	if r.bool()! {
		p.data = DebugMarkerData{
			text:            r.read_string()!
			position:        r.read_vector3()!
			color:           r.le_u32()!
			duration_millis: r.le_u64()!
		}
	}
}

pub fn (p &ClientboundDebugRendererPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.type)
	if d := p.data {
		w.bool(true)
		w.write_string(d.text)
		w.write_vector3(d.position)
		w.le_u32(d.color)
		w.le_u64(d.duration_millis)
	} else {
		w.bool(false)
	}
}
