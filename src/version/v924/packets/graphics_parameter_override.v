module packets

import serializer

pub enum GraphicsParameterOverrideType as i8 {
	sky_zenith_color          = 0
	sky_horizon_color         = 1
	horizon_blend_min         = 2
	horizon_blend_max         = 3
	horizon_blend_start       = 4
	horizon_blend_mie_start   = 5
	rayleigh_strength         = 6
	sun_mie_strength          = 7
	moon_mie_strength         = 8
	sun_glare_shape           = 9
	chlorophyll               = 10
	cdom                      = 11
	suspended_sediment        = 12
	waves_depth               = 13
	waves_frequency           = 14
	waves_frequency_scaling   = 15
	waves_speed               = 16
	waves_speed_scaling       = 17
	waves_shape               = 18
	waves_octaves             = 19
	waves_mix                 = 20
	waves_pull                = 21
	waves_direction_increment = 22
	midtones_contrast         = 23
	highlights_contrast       = 24
	shadows_contrast          = 25
}

pub struct GraphicsParameterOverrideKeyFrame {
pub mut:
	key   f32
	value [3]f32
}

pub fn (e GraphicsParameterOverrideKeyFrame) encode(mut w serializer.Writer) {
	w.le_f32(e.key)
	w.le_f32(e.value[0])
	w.le_f32(e.value[1])
	w.le_f32(e.value[2])
}

pub fn GraphicsParameterOverrideKeyFrame.decode(mut r serializer.Reader) !GraphicsParameterOverrideKeyFrame {
	return GraphicsParameterOverrideKeyFrame{
		key:   r.le_f32()!
		value: [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
}

pub struct GraphicsParameterOverridePacket {
pub mut:
	values           []GraphicsParameterOverrideKeyFrame
	float_value      f32
	vec3_value       [3]f32
	biome_identifier string
	parameter_type   GraphicsParameterOverrideType
	reset            bool
}

pub fn (p &GraphicsParameterOverridePacket) pid() u16 {
	return 331
}

pub fn (p &GraphicsParameterOverridePacket) name() string {
	return 'GraphicsParameterOverridePacket'
}

pub fn (p &GraphicsParameterOverridePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &GraphicsParameterOverridePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.values.len))
	for v in p.values {
		v.encode(mut w)
	}
	w.le_f32(p.float_value)
	w.le_f32(p.vec3_value[0])
	w.le_f32(p.vec3_value[1])
	w.le_f32(p.vec3_value[2])
	w.write_string(p.biome_identifier)
	w.i8(i8(p.parameter_type))
	w.bool(p.reset)
}

pub fn (mut p GraphicsParameterOverridePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.values = []GraphicsParameterOverrideKeyFrame{cap: count}
	for _ in 0 .. count {
		p.values << GraphicsParameterOverrideKeyFrame.decode(mut r)!
	}
	p.float_value = r.le_f32()!
	p.vec3_value = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.biome_identifier = r.read_string()!
	p.parameter_type = unsafe { GraphicsParameterOverrideType(r.i8()!) }
	p.reset = r.bool()!
}
