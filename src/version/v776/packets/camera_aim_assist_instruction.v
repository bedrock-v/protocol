module packets

import serializer
import version.v729.enums

pub struct CameraAimAssistInstructionPacket {
pub mut:
	preset_id        string
	action           enums.AimAssistAction
	allow_aim_assist bool
}

pub fn (p &CameraAimAssistInstructionPacket) pid() u16 { return 321 }

pub fn (p &CameraAimAssistInstructionPacket) name() string { return 'CameraAimAssistInstructionPacket' }

pub fn (p &CameraAimAssistInstructionPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CameraAimAssistInstructionPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.preset_id)
	p.action.encode(mut w)
	w.bool(p.allow_aim_assist)
}

pub fn (mut p CameraAimAssistInstructionPacket) decode_payload(mut r serializer.Reader) ! {
	p.preset_id = r.read_string()!
	p.action = enums.AimAssistAction.decode(mut r)!
	p.allow_aim_assist = r.bool()!
}
