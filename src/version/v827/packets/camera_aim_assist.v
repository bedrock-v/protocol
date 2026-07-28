module packets

import protocol.serializer
import protocol.version.v729.enums

pub enum TargetMode as i8 {
	angle    = 0
	distance = 1
}

pub fn (e TargetMode) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn TargetMode.decode(mut r serializer.Reader) !TargetMode {
	return unsafe { TargetMode(r.i8()!) }
}

pub struct CameraAimAssistPacket {
pub mut:
	preset_id         string
	view_angle        [2]f32
	distance          f32
	target_mode       TargetMode
	action            enums.AimAssistAction
	show_debug_render bool
}

pub fn (p &CameraAimAssistPacket) pid() u16 {
	return 316
}

pub fn (p &CameraAimAssistPacket) name() string {
	return 'CameraAimAssistPacket'
}

pub fn (p &CameraAimAssistPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraAimAssistPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.preset_id)
	w.le_f32(p.view_angle[0])
	w.le_f32(p.view_angle[1])
	w.le_f32(p.distance)
	p.target_mode.encode(mut w)
	p.action.encode(mut w)
	w.bool(p.show_debug_render)
}

pub fn (mut p CameraAimAssistPacket) decode_payload(mut r serializer.Reader) ! {
	p.preset_id = r.read_string()!
	p.view_angle = [r.le_f32()!, r.le_f32()!]!
	p.distance = r.le_f32()!
	p.target_mode = TargetMode.decode(mut r)!
	p.action = enums.AimAssistAction.decode(mut r)!
	p.show_debug_render = r.bool()!
}
