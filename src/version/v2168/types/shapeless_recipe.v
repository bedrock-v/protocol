module types

import serializer
import version.v662.types as types_662

pub struct ShapelessRecipe {
pub mut:
	recipe_unique_id      string
	ingredient_list       []CraftingRecipeIngredient
	production_list       []NetworkItemInstanceDescriptor
	recipe_id             types_662.Uuid
	recipe_tag            string
	priority              i32
	unlocking_requirement ?RecipeUnlockingRequirement
	network_id            i32
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
	if v := t.unlocking_requirement {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.write_varint32(t.network_id)
}

pub fn ShapelessRecipe.decode(mut r serializer.Reader) !ShapelessRecipe {
	mut t := ShapelessRecipe{}
	t.recipe_unique_id = r.read_string()!
	{
		count := int(r.read_varuint32()!)
		t.ingredient_list = []CraftingRecipeIngredient{cap: count}
		for _ in 0 .. count {
			t.ingredient_list << CraftingRecipeIngredient.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		t.production_list = []NetworkItemInstanceDescriptor{cap: count}
		for _ in 0 .. count {
			t.production_list << NetworkItemInstanceDescriptor.decode(mut r)!
		}
	}
	t.recipe_id = types_662.Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	if r.bool()! {
		t.unlocking_requirement = RecipeUnlockingRequirement.decode(mut r)!
	}
	t.network_id = r.read_varint32()!
	return t
}
