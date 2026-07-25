module types

import serializer
import version.v388.types as types_388

pub enum AnimatedTextureType as i32 {
	@none        = 0
	face         = 1
	body_32x32   = 2
	body_128x128 = 3
}

pub enum AnimationExpressionType as i32 {
	linear   = 0
	blinking = 1
}

pub struct AnimationData {
pub mut:
	image           types_388.ImageData
	texture_type    AnimatedTextureType
	frames          f32
	expression_type AnimationExpressionType
}

pub fn (t AnimationData) encode(mut w serializer.Writer) {
	t.image.encode(mut w)
	w.le_i32(i32(t.texture_type))
	w.le_f32(t.frames)
	w.le_i32(i32(t.expression_type))
}

pub fn AnimationData.decode(mut r serializer.Reader) !AnimationData {
	return AnimationData{
		image:           types_388.ImageData.decode(mut r)!
		texture_type:    unsafe { AnimatedTextureType(r.le_i32()!) }
		frames:          r.le_f32()!
		expression_type: unsafe { AnimationExpressionType(r.le_i32()!) }
	}
}
