module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct UnlockingContextNone {
pub mut:
	unlocking_ingredients []types_662.RecipeIngredient
}

pub struct UnlockingContextAlwaysUnlocked {}

pub struct UnlockingContextPlayerInWater {}

pub struct UnlockingContextPlayerHasManyItems {}

pub type UnlockingContext = UnlockingContextAlwaysUnlocked
	| UnlockingContextNone
	| UnlockingContextPlayerHasManyItems
	| UnlockingContextPlayerInWater

pub fn (t UnlockingContext) encode(mut w serializer.Writer) {
	match t {
		UnlockingContextNone {
			w.i8(0)
			w.write_varuint32(u32(t.unlocking_ingredients.len))
			for e in t.unlocking_ingredients {
				e.encode(mut w)
			}
		}
		UnlockingContextAlwaysUnlocked {
			w.i8(1)
		}
		UnlockingContextPlayerInWater {
			w.i8(2)
		}
		UnlockingContextPlayerHasManyItems {
			w.i8(3)
		}
	}
}

pub fn UnlockingContext.decode(mut r serializer.Reader) !UnlockingContext {
	d := r.i8()!
	match d {
		0 {
			count := r.read_count()!
			mut ingredients := []types_662.RecipeIngredient{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				ingredients << types_662.RecipeIngredient.decode(mut r)!
			}
			return UnlockingContextNone{
				unlocking_ingredients: ingredients
			}
		}
		1 {
			return UnlockingContextAlwaysUnlocked{}
		}
		2 {
			return UnlockingContextPlayerInWater{}
		}
		3 {
			return UnlockingContextPlayerHasManyItems{}
		}
		else {
			return error('invalid UnlockingContext ${d}')
		}
	}
}

pub struct RecipeUnlockingRequirement {
pub mut:
	context UnlockingContext = UnlockingContextNone{}
}

pub fn (t RecipeUnlockingRequirement) encode(mut w serializer.Writer) {
	t.context.encode(mut w)
}

pub fn RecipeUnlockingRequirement.decode(mut r serializer.Reader) !RecipeUnlockingRequirement {
	return RecipeUnlockingRequirement{
		context: UnlockingContext.decode(mut r)!
	}
}
