module types

import protocol.serializer

pub enum AnimatedTextureType as i32 {
	@none        = 0
	face         = 1
	body_32x32   = 2
	body_128x128 = 3
}

pub struct AnimationData {
pub mut:
	image        ImageData
	texture_type AnimatedTextureType
	frames       f32
}

pub fn (t AnimationData) encode(mut w serializer.Writer) {
	t.image.encode(mut w)
	w.le_i32(i32(t.texture_type))
	w.le_f32(t.frames)
}

pub fn AnimationData.decode(mut r serializer.Reader) !AnimationData {
	mut t := AnimationData{}
	t.image = ImageData.decode(mut r)!
	t.texture_type = unsafe { AnimatedTextureType(r.le_i32()!) }
	t.frames = r.le_f32()!
	return t
}
