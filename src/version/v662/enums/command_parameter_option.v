module enums

import serializer

pub enum CommandParameterOption as u32 {
	@none                       = 0
	enum_autocomplete_expansion = 0x01
	has_semantic_constraint     = 0x02
	enum_as_chained_command     = 0x04
}

pub fn (e CommandParameterOption) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn CommandParameterOption.decode(mut r serializer.Reader) !CommandParameterOption {
	return unsafe { CommandParameterOption(r.read_varuint32()!) }
}
