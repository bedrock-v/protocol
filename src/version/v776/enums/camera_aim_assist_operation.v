module enums

import serializer

pub enum CameraAimAssistOperation as i8 {
	set             = 0
	add_to_existing = 1
}

pub fn (e CameraAimAssistOperation) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CameraAimAssistOperation.decode(mut r serializer.Reader) !CameraAimAssistOperation {
	return unsafe { CameraAimAssistOperation(r.i8()!) }
}
