module enums

import serializer

pub enum MovementEffectType as i32 {
	invalid     = -1
	glide_boost = 0
}

pub fn (e MovementEffectType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn MovementEffectType.decode(mut r serializer.Reader) !MovementEffectType {
	return unsafe { MovementEffectType(r.read_varint32()!) }
}
