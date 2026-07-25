module enums

import serializer

pub enum NewInteractionModel as i32 {
	touch     = 0
	crosshair = 1
	classic   = 2
	count     = 3
}

pub fn (e NewInteractionModel) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn NewInteractionModel.decode(mut r serializer.Reader) !NewInteractionModel {
	return unsafe { NewInteractionModel(r.read_varint32()!) }
}
