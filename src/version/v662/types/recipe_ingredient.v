module types

import serializer

pub struct RecipeIngredient {
pub mut:
	item_descriptor ItemDescriptorType = ItemDescInvalid{}
	stack_size      i32
}

pub fn (t RecipeIngredient) encode(mut w serializer.Writer) {
	t.item_descriptor.encode(mut w)
	w.write_varint32(t.stack_size)
}

pub fn RecipeIngredient.decode(mut r serializer.Reader) !RecipeIngredient {
	return RecipeIngredient{
		item_descriptor: ItemDescriptorType.decode(mut r)!
		stack_size:      r.read_varint32()!
	}
}
