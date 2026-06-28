module protocol

import serializer

pub struct ClientCameraAimAssistPacket {
pub mut:
	preset_id        string
	action_type      u8
	allow_aim_assist bool
}

pub fn (p &ClientCameraAimAssistPacket) pid() u16 {
	return client_camera_aim_assist_packet
}

pub fn (p &ClientCameraAimAssistPacket) name() string {
	return 'ClientCameraAimAssistPacket'
}

pub fn (p &ClientCameraAimAssistPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientCameraAimAssistPacket) decode_payload(mut r serializer.Reader) ! {
	p.preset_id = r.read_string()!
	p.action_type = r.u8()!
	p.allow_aim_assist = r.bool()!
}

pub fn (p &ClientCameraAimAssistPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.preset_id)
	w.u8(p.action_type)
	w.bool(p.allow_aim_assist)
}
