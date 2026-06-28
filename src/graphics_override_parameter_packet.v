module protocol

import serializer
import types

pub struct ParameterKeyframeValue {
pub mut:
	time  f32
	value types.Vector3
}

pub struct GraphicsOverrideParameterPacket {
pub mut:
	values            []ParameterKeyframeValue
	unknown_float     ?f32
	unknown_vector3   ?types.Vector3
	biome_identifier  string
	player_identifier ?string
	parameter_type    u8
	reset             bool
}

pub fn (p &GraphicsOverrideParameterPacket) pid() u16 {
	return graphics_override_parameter_packet
}

pub fn (p &GraphicsOverrideParameterPacket) name() string {
	return 'GraphicsOverrideParameterPacket'
}

pub fn (p &GraphicsOverrideParameterPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p GraphicsOverrideParameterPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.values = []ParameterKeyframeValue{}
	for _ in 0 .. count {
		p.values << ParameterKeyframeValue{
			time:  r.le_f32()!
			value: r.read_vector3()!
		}
	}
	if r.bool()! {
		p.unknown_float = r.le_f32()!
	}
	if r.bool()! {
		p.unknown_vector3 = r.read_vector3()!
	}
	p.biome_identifier = r.read_string()!
	if r.bool()! {
		p.player_identifier = r.read_string()!
	}
	p.parameter_type = r.u8()!
	p.reset = r.bool()!
}

pub fn (p &GraphicsOverrideParameterPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.values.len))
	for v in p.values {
		w.le_f32(v.time)
		w.write_vector3(v.value)
	}
	if f := p.unknown_float {
		w.bool(true)
		w.le_f32(f)
	} else {
		w.bool(false)
	}
	if v := p.unknown_vector3 {
		w.bool(true)
		w.write_vector3(v)
	} else {
		w.bool(false)
	}
	w.write_string(p.biome_identifier)
	if id := p.player_identifier {
		w.bool(true)
		w.write_string(id)
	} else {
		w.bool(false)
	}
	w.u8(p.parameter_type)
	w.bool(p.reset)
}
