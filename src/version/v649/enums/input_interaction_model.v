module enums

import protocol.serializer

pub enum InputInteractionModel as u32 {
	touch     = 0
	crosshair = 1
	classic   = 2
}

pub fn (e InputInteractionModel) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InputInteractionModel.decode(mut r serializer.Reader) !InputInteractionModel {
	return unsafe { InputInteractionModel(r.read_varuint32()!) }
}
