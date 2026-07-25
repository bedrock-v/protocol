module types

import serializer

pub struct ContainerMixData {
pub mut:
	input_id   i32
	reagent_id i32
	output_id  i32
}

pub fn (t ContainerMixData) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_id)
	w.write_varint32(t.reagent_id)
	w.write_varint32(t.output_id)
}

pub fn ContainerMixData.decode(mut r serializer.Reader) !ContainerMixData {
	return ContainerMixData{
		input_id:   r.read_varint32()!
		reagent_id: r.read_varint32()!
		output_id:  r.read_varint32()!
	}
}
