module types

import serializer

pub struct PotionMixData {
pub mut:
	input_id   i32
	reagent_id i32
	output_id  i32
}

pub fn (t PotionMixData) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_id)
	w.write_varint32(t.reagent_id)
	w.write_varint32(t.output_id)
}

pub fn PotionMixData.decode(mut r serializer.Reader) !PotionMixData {
	return PotionMixData{
		input_id:   r.read_varint32()!
		reagent_id: r.read_varint32()!
		output_id:  r.read_varint32()!
	}
}
