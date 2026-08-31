module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct CameraShakePacket {
pub mut:
	intensity    f32
	seconds      f32
	shake_type   enums.CameraShakeType
	shake_action enums.CameraShakeAction
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
	w.le_f32(p.seconds)
	p.shake_type.encode(mut w)
	p.shake_action.encode(mut w)
}

pub fn (mut p CameraShakePacket) decode_payload(mut r serializer.Reader) ! {
	p.intensity = r.le_f32()!
	p.seconds = r.le_f32()!
	p.shake_type = enums.CameraShakeType.decode(mut r)!
	p.shake_action = enums.CameraShakeAction.decode(mut r)!
}
