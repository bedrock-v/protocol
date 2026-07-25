module enums

import serializer

pub enum CameraAudioListener as u8 {
	camera = 0
	player = 1
}

pub fn (e CameraAudioListener) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn CameraAudioListener.decode(mut r serializer.Reader) !CameraAudioListener {
	return unsafe { CameraAudioListener(r.u8()!) }
}
