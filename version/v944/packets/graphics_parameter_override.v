module packets

import protocol.serializer

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
	highlights_gain           = 26
	highlights_gamma          = 27
	highlights_offset         = 28
	highlights_saturation     = 29
	midtones_gain             = 30
	midtones_gamma            = 31
	midtones_offset           = 32
	midtones_saturation       = 33
	shadows_gain              = 34
	shadows_gamma             = 35
	shadows_offset            = 36
	shadows_saturation        = 37
	highlights_min            = 38
	shadows_max               = 39
	temperature               = 40
	sun_color                 = 41
	sun_illuminance           = 42
	moon_color                = 43
	moon_illuminance          = 44
	flash_color               = 45
	flash_illuminance         = 46
	ambient_color             = 47
	ambient_illuminance       = 48
}

pub fn (e GraphicsParameterOverrideType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn GraphicsParameterOverrideType.decode(mut r serializer.Reader) !GraphicsParameterOverrideType {
	return unsafe { GraphicsParameterOverrideType(r.i8()!) }
}

pub struct GraphicsParameterOverrideKeyFrame {
pub mut:
	key   f32
	value [3]f32
}

pub fn (t GraphicsParameterOverrideKeyFrame) encode(mut w serializer.Writer) {
	w.le_f32(t.key)
	w.le_f32(t.value[0])
	w.le_f32(t.value[1])
	w.le_f32(t.value[2])
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
	for e in p.values {
		e.encode(mut w)
	}
	w.le_f32(p.float_value)
	w.le_f32(p.vec3_value[0])
	w.le_f32(p.vec3_value[1])
	w.le_f32(p.vec3_value[2])
	w.write_string(p.biome_identifier)
	p.parameter_type.encode(mut w)
	w.bool(p.reset)
}

pub fn (mut p GraphicsParameterOverridePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.values = []GraphicsParameterOverrideKeyFrame{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.values << GraphicsParameterOverrideKeyFrame.decode(mut r)!
	}
	p.float_value = r.le_f32()!
	p.vec3_value = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.biome_identifier = r.read_string()!
	p.parameter_type = GraphicsParameterOverrideType.decode(mut r)!
	p.reset = r.bool()!
}
