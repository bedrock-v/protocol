module types

import serializer

pub struct ShulkerBoxRecipe {
pub mut:
	recipe_unique_id string
	ingredient_list  []RecipeIngredient
	production_list  []NetworkItemInstanceDescriptor
	recipe_id        Uuid
	recipe_tag       string
	priority         i32
	network_id       u32
}

pub fn (t ShulkerBoxRecipe) encode(mut w serializer.Writer) {
	w.write_string(t.recipe_unique_id)
	w.write_varuint32(u32(t.ingredient_list.len))
	for e in t.ingredient_list {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.production_list.len))
	for e in t.production_list {
		e.encode(mut w)
	}
	t.recipe_id.encode(mut w)
	w.write_string(t.recipe_tag)
	w.write_varint32(t.priority)
	w.write_varuint32(t.network_id)
}

pub fn ShulkerBoxRecipe.decode(mut r serializer.Reader) !ShulkerBoxRecipe {
	mut t := ShulkerBoxRecipe{}
	t.recipe_unique_id = r.read_string()!
	ing_count := int(r.read_varuint32()!)
	t.ingredient_list = []RecipeIngredient{cap: ing_count}
	for _ in 0 .. ing_count {
		t.ingredient_list << RecipeIngredient.decode(mut r)!
	}
	prod_count := int(r.read_varuint32()!)
	t.production_list = []NetworkItemInstanceDescriptor{cap: prod_count}
	for _ in 0 .. prod_count {
		t.production_list << NetworkItemInstanceDescriptor.decode(mut r)!
	}
	t.recipe_id = Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	t.network_id = r.read_varuint32()!
	return t
}
