module enums

import serializer

pub enum AttributeModifierOperation as i32 {
	addition         = 0
	multiply_base    = 1
	multiply_total   = 2
	cap              = 3
	total_operations = 4
}

pub fn (e AttributeModifierOperation) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn AttributeModifierOperation.decode(mut r serializer.Reader) !AttributeModifierOperation {
	return unsafe { AttributeModifierOperation(r.le_i32()!) }
}
