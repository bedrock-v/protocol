module enums

import serializer

pub enum EducationEditionOffer as i32 {
	@none         = 0
	rest_of_world = 1
	china         = 2
}

pub fn (e EducationEditionOffer) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn EducationEditionOffer.decode(mut r serializer.Reader) !EducationEditionOffer {
	return unsafe { EducationEditionOffer(r.read_varint32()!) }
}
