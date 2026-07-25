module types

import serializer

pub struct SmithingTrimRecipe {
pub mut:
	recipe_id           string
	template_ingredient RecipeIngredient
	base_ingredient     RecipeIngredient
	addition_ingredient RecipeIngredient
	tag                 string
	network_id          u32
}

pub fn (t SmithingTrimRecipe) encode(mut w serializer.Writer) {
	w.write_string(t.recipe_id)
	t.template_ingredient.encode(mut w)
	t.base_ingredient.encode(mut w)
	t.addition_ingredient.encode(mut w)
	w.write_string(t.tag)
	w.write_varuint32(t.network_id)
}

pub fn SmithingTrimRecipe.decode(mut r serializer.Reader) !SmithingTrimRecipe {
	return SmithingTrimRecipe{
		recipe_id:           r.read_string()!
		template_ingredient: RecipeIngredient.decode(mut r)!
		base_ingredient:     RecipeIngredient.decode(mut r)!
		addition_ingredient: RecipeIngredient.decode(mut r)!
		tag:                 r.read_string()!
		network_id:          r.read_varuint32()!
	}
}
