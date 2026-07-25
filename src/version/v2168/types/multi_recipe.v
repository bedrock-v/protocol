module types

import serializer
import version.v662.types as types_662

pub struct MultiRecipe {
pub mut:
	multi_recipe_id types_662.Uuid
	network_id      i32
}

pub fn (t MultiRecipe) encode(mut w serializer.Writer) {
	t.multi_recipe_id.encode(mut w)
	w.write_varint32(t.network_id)
}

pub fn MultiRecipe.decode(mut r serializer.Reader) !MultiRecipe {
	return MultiRecipe{
		multi_recipe_id: types_662.Uuid.decode(mut r)!
		network_id:      r.read_varint32()!
	}
}
