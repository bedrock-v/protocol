module types

import serializer

pub struct MolangVariableMap {
pub mut:
	serialized_variable_map string
}

pub fn (t MolangVariableMap) encode(mut w serializer.Writer) {
	w.write_string(t.serialized_variable_map)
}

pub fn MolangVariableMap.decode(mut r serializer.Reader) !MolangVariableMap {
	return MolangVariableMap{
		serialized_variable_map: r.read_string()!
	}
}
