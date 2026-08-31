module enums

import protocol.serializer

pub enum AimAssistAction as i8 {
	set   = 0
	clear = 1
}

pub fn (e AimAssistAction) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn AimAssistAction.decode(mut r serializer.Reader) !AimAssistAction {
	return unsafe { AimAssistAction(r.i8()!) }
}
