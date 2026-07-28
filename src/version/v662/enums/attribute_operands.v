module enums

import protocol.serializer

pub enum AttributeOperands as i32 {
	min            = 0
	max            = 1
	current        = 2
	total_operands = 3
}

pub fn (e AttributeOperands) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn AttributeOperands.decode(mut r serializer.Reader) !AttributeOperands {
	return unsafe { AttributeOperands(r.le_i32()!) }
}
