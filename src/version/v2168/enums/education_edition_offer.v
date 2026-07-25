module enums

import serializer

pub enum EducationEditionOffer as u32 {
	@none         = 0
	rest_of_world = 1
	china         = 2
}

pub fn (e EducationEditionOffer) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn EducationEditionOffer.decode(mut r serializer.Reader) !EducationEditionOffer {
	return unsafe { EducationEditionOffer(r.read_varuint32()!) }
}
