module packets

import protocol.serializer
import protocol.version.v729.enums

pub enum TargetMode as i8 {
	angle    = 0
	distance = 1
}

pub struct CameraAimAssistPacket {
pub mut:
	view_angle  [2]f32
	distance    f32
	target_mode TargetMode
	action      enums.AimAssistAction
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
	w.le_f32(p.view_angle[0])
	w.le_f32(p.view_angle[1])
	w.le_f32(p.distance)
	w.i8(i8(p.target_mode))
	p.action.encode(mut w)
}

pub fn (mut p CameraAimAssistPacket) decode_payload(mut r serializer.Reader) ! {
	p.view_angle = [r.le_f32()!, r.le_f32()!]!
	p.distance = r.le_f32()!
	p.target_mode = unsafe { TargetMode(r.i8()!) }
	p.action = enums.AimAssistAction.decode(mut r)!
}
