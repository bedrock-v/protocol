module packets

import protocol.serializer
import protocol.version.v575.types

pub struct CameraInstructionPacket {
pub mut:
	camera_instruction types.CameraInstruction
}

pub fn (p &CameraInstructionPacket) pid() u16 {
	return 300
}

pub fn (p &CameraInstructionPacket) name() string {
	return 'CameraInstructionPacket'
}

pub fn (p &CameraInstructionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraInstructionPacket) encode_payload(mut w serializer.Writer) {
	p.camera_instruction.encode(mut w)
}

pub fn (mut p CameraInstructionPacket) decode_payload(mut r serializer.Reader) ! {
	p.camera_instruction = types.CameraInstruction.decode(mut r)!
}
