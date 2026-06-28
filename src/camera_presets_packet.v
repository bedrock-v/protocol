module protocol

import serializer
import types

pub struct CameraPresetAimAssist {
pub mut:
	has_preset      bool
	preset          string
	has_target_mode bool
	target_mode     int
	has_angle       bool
	angle           types.Vector2
	has_distance    bool
	distance        f32
}

pub struct CameraPreset {
pub mut:
	name   string
	parent string

	has_pos_x         bool
	pos_x             f32
	has_pos_y         bool
	pos_y             f32
	has_pos_z         bool
	pos_z             f32
	has_rot_x         bool
	rot_x             f32
	has_rot_y         bool
	rot_y             f32
	has_rotation_speed bool
	rotation_speed    f32
	has_snap_to_target bool
	snap_to_target    bool
	has_horizontal_rotation_limit bool
	horizontal_rotation_limit     types.Vector2
	has_vertical_rotation_limit   bool
	vertical_rotation_limit       types.Vector2
	has_continue_targeting bool
	continue_targeting     bool
	has_tracking_radius    bool
	tracking_radius        f32
	has_view_offset        bool
	view_offset            types.Vector2
	has_entity_offset      bool
	entity_offset          types.Vector3
	has_radius             bool
	radius                 f32
	has_min_yaw_limit      bool
	min_yaw_limit          f32
	has_max_yaw_limit      bool
	max_yaw_limit          f32
	has_audio_listener     bool
	audio_listener         u8
	has_player_effects     bool
	player_effects         bool
	has_aim_assist         bool
	aim_assist             CameraPresetAimAssist
	has_control_scheme     bool
	control_scheme         u8
}

pub struct CameraPresetsPacket {
pub mut:
	presets []CameraPreset
}

pub fn (p &CameraPresetsPacket) pid() u16 {
	return camera_presets_packet
}

pub fn (p &CameraPresetsPacket) name() string {
	return 'CameraPresetsPacket'
}

pub fn (p &CameraPresetsPacket) can_be_sent_before_login() bool {
	return false
}

fn read_camera_preset_aim_assist(mut r serializer.Reader) !CameraPresetAimAssist {
	mut a := CameraPresetAimAssist{}
	if r.bool()! {
		a.has_preset = true
		a.preset = r.read_string()!
	}
	if r.bool()! {
		a.has_target_mode = true
		a.target_mode = r.le_i32()!
	}
	if r.bool()! {
		a.has_angle = true
		a.angle = r.read_vector2()!
	}
	if r.bool()! {
		a.has_distance = true
		a.distance = r.le_f32()!
	}
	return a
}

fn write_camera_preset_aim_assist(mut w serializer.Writer, a CameraPresetAimAssist) {
	if a.has_preset {
		w.bool(true)
		w.write_string(a.preset)
	} else {
		w.bool(false)
	}
	if a.has_target_mode {
		w.bool(true)
		w.le_i32(a.target_mode)
	} else {
		w.bool(false)
	}
	if a.has_angle {
		w.bool(true)
		w.write_vector2(a.angle)
	} else {
		w.bool(false)
	}
	if a.has_distance {
		w.bool(true)
		w.le_f32(a.distance)
	} else {
		w.bool(false)
	}
}

fn read_camera_preset(mut r serializer.Reader) !CameraPreset {
	mut c := CameraPreset{
		name:   r.read_string()!
		parent: r.read_string()!
	}
	if r.bool()! {
		c.has_pos_x = true
		c.pos_x = r.le_f32()!
	}
	if r.bool()! {
		c.has_pos_y = true
		c.pos_y = r.le_f32()!
	}
	if r.bool()! {
		c.has_pos_z = true
		c.pos_z = r.le_f32()!
	}
	if r.bool()! {
		c.has_rot_x = true
		c.rot_x = r.le_f32()!
	}
	if r.bool()! {
		c.has_rot_y = true
		c.rot_y = r.le_f32()!
	}
	if r.bool()! {
		c.has_rotation_speed = true
		c.rotation_speed = r.le_f32()!
	}
	if r.bool()! {
		c.has_snap_to_target = true
		c.snap_to_target = r.bool()!
	}
	if r.bool()! {
		c.has_horizontal_rotation_limit = true
		c.horizontal_rotation_limit = r.read_vector2()!
	}
	if r.bool()! {
		c.has_vertical_rotation_limit = true
		c.vertical_rotation_limit = r.read_vector2()!
	}
	if r.bool()! {
		c.has_continue_targeting = true
		c.continue_targeting = r.bool()!
	}
	if r.bool()! {
		c.has_tracking_radius = true
		c.tracking_radius = r.le_f32()!
	}
	if r.bool()! {
		c.has_view_offset = true
		c.view_offset = r.read_vector2()!
	}
	if r.bool()! {
		c.has_entity_offset = true
		c.entity_offset = r.read_vector3()!
	}
	if r.bool()! {
		c.has_radius = true
		c.radius = r.le_f32()!
	}
	if r.bool()! {
		c.has_min_yaw_limit = true
		c.min_yaw_limit = r.le_f32()!
	}
	if r.bool()! {
		c.has_max_yaw_limit = true
		c.max_yaw_limit = r.le_f32()!
	}
	if r.bool()! {
		c.has_audio_listener = true
		c.audio_listener = r.u8()!
	}
	if r.bool()! {
		c.has_player_effects = true
		c.player_effects = r.bool()!
	}
	if r.bool()! {
		c.has_aim_assist = true
		c.aim_assist = read_camera_preset_aim_assist(mut r)!
	}
	if r.bool()! {
		c.has_control_scheme = true
		c.control_scheme = r.u8()!
	}
	return c
}

fn write_camera_preset(mut w serializer.Writer, c CameraPreset) {
	w.write_string(c.name)
	w.write_string(c.parent)
	if c.has_pos_x {
		w.bool(true)
		w.le_f32(c.pos_x)
	} else {
		w.bool(false)
	}
	if c.has_pos_y {
		w.bool(true)
		w.le_f32(c.pos_y)
	} else {
		w.bool(false)
	}
	if c.has_pos_z {
		w.bool(true)
		w.le_f32(c.pos_z)
	} else {
		w.bool(false)
	}
	if c.has_rot_x {
		w.bool(true)
		w.le_f32(c.rot_x)
	} else {
		w.bool(false)
	}
	if c.has_rot_y {
		w.bool(true)
		w.le_f32(c.rot_y)
	} else {
		w.bool(false)
	}
	if c.has_rotation_speed {
		w.bool(true)
		w.le_f32(c.rotation_speed)
	} else {
		w.bool(false)
	}
	if c.has_snap_to_target {
		w.bool(true)
		w.bool(c.snap_to_target)
	} else {
		w.bool(false)
	}
	if c.has_horizontal_rotation_limit {
		w.bool(true)
		w.write_vector2(c.horizontal_rotation_limit)
	} else {
		w.bool(false)
	}
	if c.has_vertical_rotation_limit {
		w.bool(true)
		w.write_vector2(c.vertical_rotation_limit)
	} else {
		w.bool(false)
	}
	if c.has_continue_targeting {
		w.bool(true)
		w.bool(c.continue_targeting)
	} else {
		w.bool(false)
	}
	if c.has_tracking_radius {
		w.bool(true)
		w.le_f32(c.tracking_radius)
	} else {
		w.bool(false)
	}
	if c.has_view_offset {
		w.bool(true)
		w.write_vector2(c.view_offset)
	} else {
		w.bool(false)
	}
	if c.has_entity_offset {
		w.bool(true)
		w.write_vector3(c.entity_offset)
	} else {
		w.bool(false)
	}
	if c.has_radius {
		w.bool(true)
		w.le_f32(c.radius)
	} else {
		w.bool(false)
	}
	if c.has_min_yaw_limit {
		w.bool(true)
		w.le_f32(c.min_yaw_limit)
	} else {
		w.bool(false)
	}
	if c.has_max_yaw_limit {
		w.bool(true)
		w.le_f32(c.max_yaw_limit)
	} else {
		w.bool(false)
	}
	if c.has_audio_listener {
		w.bool(true)
		w.u8(c.audio_listener)
	} else {
		w.bool(false)
	}
	if c.has_player_effects {
		w.bool(true)
		w.bool(c.player_effects)
	} else {
		w.bool(false)
	}
	if c.has_aim_assist {
		w.bool(true)
		write_camera_preset_aim_assist(mut w, c.aim_assist)
	} else {
		w.bool(false)
	}
	if c.has_control_scheme {
		w.bool(true)
		w.u8(c.control_scheme)
	} else {
		w.bool(false)
	}
}

pub fn (mut p CameraPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.presets = []CameraPreset{}
	for _ in 0 .. count {
		p.presets << read_camera_preset(mut r)!
	}
}

pub fn (p &CameraPresetsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.presets.len))
	for c in p.presets {
		write_camera_preset(mut w, c)
	}
}
