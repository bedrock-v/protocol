module types

import protocol.serializer

pub struct SmithingTrimRecipe {
pub mut:
	recipe_id           string
	template_ingredient CraftingRecipeIngredient
	base_ingredient     CraftingRecipeIngredient
	addition_ingredient CraftingRecipeIngredient
	tag                 string
	network_id          i32
}

pub fn (t SmithingTrimRecipe) encode(mut w serializer.Writer) {
	w.write_string(t.recipe_id)
	t.template_ingredient.encode(mut w)
	t.base_ingredient.encode(mut w)
	t.addition_ingredient.encode(mut w)
	w.write_string(t.tag)
	w.write_varint32(t.network_id)
}

pub fn SmithingTrimRecipe.decode(mut r serializer.Reader) !SmithingTrimRecipe {
	return SmithingTrimRecipe{
		recipe_id:           r.read_string()!
		template_ingredient: CraftingRecipeIngredient.decode(mut r)!
		base_ingredient:     CraftingRecipeIngredient.decode(mut r)!
		addition_ingredient: CraftingRecipeIngredient.decode(mut r)!
		tag:                 r.read_string()!
		network_id:          r.read_varint32()!
	}
}
