module packets

import protocol.serializer
import protocol.version.v618.types

pub struct CameraInstructionPacket {
pub mut:
	set_instruction  ?types.CameraSetInstruction
	clear            ?bool
	fade_instruction ?types.CameraFadeInstruction
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
	if v := p.set_instruction {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	if v := p.clear {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := p.fade_instruction {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p CameraInstructionPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.set_instruction = types.CameraSetInstruction.decode(mut r)!
	}
	if r.bool()! {
		p.clear = r.bool()!
	}
	if r.bool()! {
		p.fade_instruction = types.CameraFadeInstruction.decode(mut r)!
	}
}
