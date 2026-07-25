module enums

import serializer

pub enum AnimationExpression as u32 {
	linear   = 0
	blinking = 1
}

pub fn (e AnimationExpression) encode(mut w serializer.Writer) {
	w.le_u32(u32(e))
}

pub fn AnimationExpression.decode(mut r serializer.Reader) !AnimationExpression {
	return unsafe { AnimationExpression(r.le_u32()!) }
}
