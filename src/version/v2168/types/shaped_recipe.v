module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ShapedRecipe {
pub mut:
	recipe_unique_id      string
	width                 i32
	height                i32
	ingredients           []CraftingRecipeIngredient
	production_list       []NetworkItemInstanceDescriptor
	recipe_id             types_662.Uuid
	recipe_tag            string
	priority              i32
	assume_symmetry       bool
	unlocking_requirement ?RecipeUnlockingRequirement
	network_id            i32
}

pub fn (t ShapedRecipe) encode(mut w serializer.Writer) {
	w.write_string(t.recipe_unique_id)
	w.write_varint32(t.width)
	w.write_varint32(t.height)
	w.write_varuint32(u32(t.ingredients.len))
	for e in t.ingredients {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.production_list.len))
	for e in t.production_list {
		e.encode(mut w)
	}
	t.recipe_id.encode(mut w)
	w.write_string(t.recipe_tag)
	w.write_varint32(t.priority)
	w.bool(t.assume_symmetry)
	if v := t.unlocking_requirement {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.write_varint32(t.network_id)
}

pub fn ShapedRecipe.decode(mut r serializer.Reader) !ShapedRecipe {
	mut t := ShapedRecipe{}
	t.recipe_unique_id = r.read_string()!
	t.width = r.read_varint32()!
	t.height = r.read_varint32()!
	{
		count := int(r.read_varuint32()!)
		t.ingredients = []CraftingRecipeIngredient{cap: count}
		for _ in 0 .. count {
			t.ingredients << CraftingRecipeIngredient.decode(mut r)!
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
	t.assume_symmetry = r.bool()!
	if r.bool()! {
		t.unlocking_requirement = RecipeUnlockingRequirement.decode(mut r)!
	}
	t.network_id = r.read_varint32()!
	return t
}
