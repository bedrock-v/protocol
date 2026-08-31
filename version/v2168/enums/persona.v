module enums

import protocol.serializer

pub enum AnimatedTextureType as u32 {
	@none       = 0
	face        = 1
	body32x32   = 2
	body128x128 = 3
}

pub fn (e AnimatedTextureType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn AnimatedTextureType.decode(mut r serializer.Reader) !AnimatedTextureType {
	return unsafe { AnimatedTextureType(r.read_varuint32()!) }
}

pub enum AnimationExpression as u32 {
	linear   = 0
	blinking = 1
}

pub fn (e AnimationExpression) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn AnimationExpression.decode(mut r serializer.Reader) !AnimationExpression {
	return unsafe { AnimationExpression(r.read_varuint32()!) }
}

pub enum ArmSizeType as u8 {
	slim = 0
	wide = 1
}

pub fn (e ArmSizeType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn ArmSizeType.decode(mut r serializer.Reader) !ArmSizeType {
	return unsafe { ArmSizeType(r.u8()!) }
}

pub enum PersonaPieceType as i32 {
	skeleton       = 0
	body           = 1
	skin           = 2
	bottom         = 3
	feet           = 4
	dress          = 5
	top            = 6
	high_pants     = 7
	hands          = 8
	outerwear      = 9
	facial_hair    = 10
	mouth          = 11
	eyes           = 12
	hair           = 13
	hood           = 14
	back           = 15
	face_accessory = 16
	head           = 17
	legs           = 18
	left_leg       = 19
	right_leg      = 20
	arms           = 21
	left_arm       = 22
	right_arm      = 23
	capes          = 24
	classic_skin   = 25
	emote          = 26
}

pub fn (e PersonaPieceType) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn PersonaPieceType.decode(mut r serializer.Reader) !PersonaPieceType {
	return unsafe { PersonaPieceType(r.le_i32()!) }
}
