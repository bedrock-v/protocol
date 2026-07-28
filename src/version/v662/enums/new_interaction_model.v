module enums

import protocol.serializer

pub enum NewInteractionModel as u32 {
	touch     = 0
	crosshair = 1
	classic   = 2
	count     = 3
}

pub fn (e NewInteractionModel) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn NewInteractionModel.decode(mut r serializer.Reader) !NewInteractionModel {
	return unsafe { NewInteractionModel(r.read_varuint32()!) }
}
