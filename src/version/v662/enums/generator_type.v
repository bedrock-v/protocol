module enums

import serializer

pub enum GeneratorType as i32 {
	legacy    = 0
	overworld = 1
	flat      = 2
	nether    = 3
	the_end   = 4
	void      = 5
	undefined = 6
}

pub fn (e GeneratorType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn GeneratorType.decode(mut r serializer.Reader) !GeneratorType {
	return unsafe { GeneratorType(r.read_varint32()!) }
}
