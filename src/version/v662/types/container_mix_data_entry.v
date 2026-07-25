module types

import serializer

pub struct ContainerMixDataEntry {
pub mut:
	input_item_id   i32
	reagent_item_id i32
	output_item_id  i32
}

pub fn (t ContainerMixDataEntry) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_item_id)
	w.write_varint32(t.reagent_item_id)
	w.write_varint32(t.output_item_id)
}

pub fn ContainerMixDataEntry.decode(mut r serializer.Reader) !ContainerMixDataEntry {
	return ContainerMixDataEntry{
		input_item_id:   r.read_varint32()!
		reagent_item_id: r.read_varint32()!
		output_item_id:  r.read_varint32()!
	}
}
