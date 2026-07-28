module enums

import protocol.serializer

pub enum CameraShakeType as i8 {
	positional = 0
	rotational = 1
}

pub fn (e CameraShakeType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CameraShakeType.decode(mut r serializer.Reader) !CameraShakeType {
	return unsafe { CameraShakeType(r.i8()!) }
}
