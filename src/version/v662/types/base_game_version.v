module types

import serializer

pub struct BaseGameVersion {
pub mut:
	value string
}

pub fn (t BaseGameVersion) encode(mut w serializer.Writer) {
	w.write_string(t.value)
}

pub fn BaseGameVersion.decode(mut r serializer.Reader) !BaseGameVersion {
	return BaseGameVersion{
		value: r.read_string()!
	}
}
