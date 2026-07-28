module types

import protocol.serializer
import protocol.version.v2168.enums

pub struct RecipeIngredient {
pub mut:
	item_descriptor enums.ItemDescriptorType = enums.ItemDescEmpty{}
	stack_size      i16
}

pub fn (t RecipeIngredient) encode(mut w serializer.Writer) {
	t.item_descriptor.encode(mut w)
	w.le_i16(t.stack_size)
}

pub fn RecipeIngredient.decode(mut r serializer.Reader) !RecipeIngredient {
	return RecipeIngredient{
		item_descriptor: enums.ItemDescriptorType.decode(mut r)!
		stack_size:      r.le_i16()!
	}
}
