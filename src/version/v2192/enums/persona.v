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
	unknown        = 0
	skeleton       = 1
	body           = 2
	skin           = 3
	bottom         = 4
	feet           = 5
	dress          = 6
	top            = 7
	high_pants     = 8
	hands          = 9
	outerwear      = 10
	facial_hair    = 11
	mouth          = 12
	eyes           = 13
	hair           = 14
	hood           = 15
	back           = 16
	face_accessory = 17
	head           = 18
	legs           = 19
	left_leg       = 20
	right_leg      = 21
	arms           = 22
	left_arm       = 23
	right_arm      = 24
	capes          = 25
	classic_skin   = 26
	emote          = 27

	unsupported = 28
}

pub fn (e PersonaPieceType) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn PersonaPieceType.decode(mut r serializer.Reader) !PersonaPieceType {
	return unsafe { PersonaPieceType(r.le_i32()!) }
}
