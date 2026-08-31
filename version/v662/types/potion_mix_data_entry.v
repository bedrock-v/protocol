module types

import protocol.serializer

pub struct PotionMixDataEntry {
pub mut:
	input_potion_id  i32
	input_item_aux   i32
	reagent_item_id  i32
	reagent_item_aux i32
	output_potion_id i32
	output_item_aux  i32
}

pub fn (t PotionMixDataEntry) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_potion_id)
	w.write_varint32(t.input_item_aux)
	w.write_varint32(t.reagent_item_id)
	w.write_varint32(t.reagent_item_aux)
	w.write_varint32(t.output_potion_id)
	w.write_varint32(t.output_item_aux)
}

pub fn PotionMixDataEntry.decode(mut r serializer.Reader) !PotionMixDataEntry {
	return PotionMixDataEntry{
		input_potion_id:  r.read_varint32()!
		input_item_aux:   r.read_varint32()!
		reagent_item_id:  r.read_varint32()!
		reagent_item_aux: r.read_varint32()!
		output_potion_id: r.read_varint32()!
		output_item_aux:  r.read_varint32()!
	}
}
