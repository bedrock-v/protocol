module protocol

import serializer

pub struct CameraShakePacket {
pub mut:
	intensity    f32
	duration     f32
	shake_type   int
	shake_action int
}

pub fn (p &CameraShakePacket) pid() u16 {
	return camera_shake_packet
}

pub fn (p &CameraShakePacket) name() string {
	return 'CameraShakePacket'
}

pub fn (p &CameraShakePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CameraShakePacket) decode_payload(mut r serializer.Reader) ! {
	p.intensity = r.le_f32()!
	p.duration = r.le_f32()!
	p.shake_type = int(r.u8()!)
	p.shake_action = int(r.u8()!)
}

pub fn (p &CameraShakePacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.intensity)
	w.le_f32(p.duration)
	w.u8(u8(p.shake_type))
	w.u8(u8(p.shake_action))
}
