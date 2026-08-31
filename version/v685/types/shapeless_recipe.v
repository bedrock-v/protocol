module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ShapelessRecipe {
pub mut:
	recipe_unique_id      string
	ingredient_list       []types_662.RecipeIngredient
	production_list       []types_662.NetworkItemInstanceDescriptor
	recipe_id             types_662.Uuid
	recipe_tag            string
	priority              i32
	unlocking_requirement RecipeUnlockingRequirement
	network_id            u32
}

pub fn (t ShapelessRecipe) encode(mut w serializer.Writer) {
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
	t.unlocking_requirement.encode(mut w)
	w.write_varuint32(t.network_id)
}

pub fn ShapelessRecipe.decode(mut r serializer.Reader) !ShapelessRecipe {
	mut t := ShapelessRecipe{}
	t.recipe_unique_id = r.read_string()!
	ing_count := r.read_count()!
	t.ingredient_list = []types_662.RecipeIngredient{cap: serializer.prealloc(ing_count)}
	for _ in 0 .. ing_count {
		t.ingredient_list << types_662.RecipeIngredient.decode(mut r)!
	}
	prod_count := r.read_count()!
	t.production_list = []types_662.NetworkItemInstanceDescriptor{cap: serializer.prealloc(prod_count)}
	for _ in 0 .. prod_count {
		t.production_list << types_662.NetworkItemInstanceDescriptor.decode(mut r)!
	}
	t.recipe_id = types_662.Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	t.unlocking_requirement = RecipeUnlockingRequirement.decode(mut r)!
	t.network_id = r.read_varuint32()!
	return t
}
