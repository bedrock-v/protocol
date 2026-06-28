module protocol

import serializer
import types

pub struct CameraAimAssistPacket {
pub mut:
	preset_id        string
	view_angle       types.Vector2
	distance         f32
	target_mode      u8
	action_type      u8
	show_debug_render bool
}

pub fn (p &CameraAimAssistPacket) pid() u16 {
	return camera_aim_assist_packet
}

pub fn (p &CameraAimAssistPacket) name() string {
	return 'CameraAimAssistPacket'
}

pub fn (p &CameraAimAssistPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CameraAimAssistPacket) decode_payload(mut r serializer.Reader) ! {
	p.preset_id = r.read_string()!
	p.view_angle = r.read_vector2()!
	p.distance = r.le_f32()!
	p.target_mode = r.u8()!
	p.action_type = r.u8()!
	p.show_debug_render = r.bool()!
}

pub fn (p &CameraAimAssistPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.preset_id)
	w.write_vector2(p.view_angle)
	w.le_f32(p.distance)
	w.u8(p.target_mode)
	w.u8(p.action_type)
	w.bool(p.show_debug_render)
}
