module types

import protocol.serializer

pub enum UnlockingContext as i32 {
	@none                 = 0
	always_unlocked       = 1
	player_in_water       = 2
	player_has_many_items = 3
}

pub fn (e UnlockingContext) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn UnlockingContext.decode(mut r serializer.Reader) !UnlockingContext {
	return unsafe { UnlockingContext(r.read_varint32()!) }
}

pub struct RecipeUnlockingRequirement {
pub mut:
	context               UnlockingContext
	unlocking_ingredients ?[]CraftingRecipeIngredient
}

pub fn (t RecipeUnlockingRequirement) encode(mut w serializer.Writer) {
	t.context.encode(mut w)
	if ingredients := t.unlocking_ingredients {
		w.bool(true)
		w.write_varuint32(u32(ingredients.len))
		for e in ingredients {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
}

pub fn RecipeUnlockingRequirement.decode(mut r serializer.Reader) !RecipeUnlockingRequirement {
	mut t := RecipeUnlockingRequirement{}
	t.context = UnlockingContext.decode(mut r)!
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut items := []CraftingRecipeIngredient{cap: count}
		for _ in 0 .. count {
			items << CraftingRecipeIngredient.decode(mut r)!
		}
		t.unlocking_ingredients = items
	}
	return t
}
