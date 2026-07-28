module enums

import protocol.serializer

pub enum AudioListener as i8 {
	camera = 0
	player = 1
}

pub fn (e AudioListener) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn AudioListener.decode(mut r serializer.Reader) !AudioListener {
	return unsafe { AudioListener(r.i8()!) }
}
