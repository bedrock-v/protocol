module enums

import serializer

pub enum CameraSplineType as i8 {
	catmull_rom = 0
	linear      = 1
}

pub fn (e CameraSplineType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn CameraSplineType.decode(mut r serializer.Reader) !CameraSplineType {
	return unsafe { CameraSplineType(r.i8()!) }
}
