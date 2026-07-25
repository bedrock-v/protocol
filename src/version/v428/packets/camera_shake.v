module packets

import serializer

pub struct CameraShakePacket {
pub mut:
	intensity    f32
	duration     f32
	shake_type   u8
	shake_action u8
}

pub fn (p &CameraShakePacket) pid() u16 {
	return 159
}

pub fn (p &CameraShakePacket) name() string {
	return 'CameraShakePacket'
}

pub fn (p &CameraShakePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraShakePacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.intensity)
	w.le_f32(p.duration)
	w.u8(p.shake_type)
	w.u8(p.shake_action)
}

pub fn (mut p CameraShakePacket) decode_payload(mut r serializer.Reader) ! {
	p.intensity = r.le_f32()!
	p.duration = r.le_f32()!
	p.shake_type = r.u8()!
	p.shake_action = r.u8()!
}
