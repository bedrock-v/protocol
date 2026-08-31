module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ShulkerBoxRecipe {
pub mut:
	recipe_unique_id      string
	ingredient_list       []RecipeIngredient
	production_list       []NetworkItemInstanceDescriptor
	recipe_id             types_662.Uuid
	recipe_tag            string
	priority              i32
	unlocking_requirement RecipeUnlockingRequirement
	network_id            u32
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
	t.unlocking_requirement.encode(mut w)
	w.write_varuint32(t.network_id)
}

pub fn ShulkerBoxRecipe.decode(mut r serializer.Reader) !ShulkerBoxRecipe {
	mut t := ShulkerBoxRecipe{}
	t.recipe_unique_id = r.read_string()!
	{
		count := r.read_count()!
		t.ingredient_list = []RecipeIngredient{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.ingredient_list << RecipeIngredient.decode(mut r)!
		}
	}
	{
		count := r.read_count()!
		t.production_list = []NetworkItemInstanceDescriptor{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.production_list << NetworkItemInstanceDescriptor.decode(mut r)!
		}
	}
	t.recipe_id = types_662.Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	t.unlocking_requirement = RecipeUnlockingRequirement.decode(mut r)!
	t.network_id = r.read_varuint32()!
	return t
}
