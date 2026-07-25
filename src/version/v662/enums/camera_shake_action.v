module enums

import serializer

pub enum CameraShakeAction as i8 {
	add  = 0
	stop = 1
}

pub fn (e CameraShakeAction) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CameraShakeAction.decode(mut r serializer.Reader) !CameraShakeAction {
	return unsafe { CameraShakeAction(r.i8()!) }
}
