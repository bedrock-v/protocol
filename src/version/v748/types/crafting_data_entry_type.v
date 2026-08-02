module types

import protocol.serializer
import protocol.version.v662.types as types_662
import protocol.version.v685.types as types_685

pub struct CraftingEntryShapeless {
pub mut:
	recipe types_685.ShapelessRecipe
}

pub struct CraftingEntryShaped {
pub mut:
	recipe types_685.ShapedRecipe
}

pub struct CraftingEntryMulti {
pub mut:
	multi_recipe types_662.Uuid
	net_id       u32
}

pub struct CraftingEntryShulkerBox {
pub mut:
	recipe ShulkerBoxRecipe
}

pub struct CraftingEntryShapelessChemistry {
pub mut:
	recipe types_685.ShapelessRecipe
}

pub struct CraftingEntryShapedChemistry {
pub mut:
	recipe types_685.ShapedRecipe
}

pub struct CraftingEntrySmithingTransform {
pub mut:
	recipe types_662.SmithingTransformRecipe
}

pub struct CraftingEntrySmithingTrim {
pub mut:
	recipe types_662.SmithingTrimRecipe
}

pub type CraftingDataEntryType = CraftingEntryMulti
	| CraftingEntryShaped
	| CraftingEntryShapedChemistry
	| CraftingEntryShapeless
	| CraftingEntryShapelessChemistry
	| CraftingEntryShulkerBox
	| CraftingEntrySmithingTransform
	| CraftingEntrySmithingTrim

pub fn (t CraftingDataEntryType) encode(mut w serializer.Writer) {
	match t {
		CraftingEntryShapeless {
			w.write_varint32(0)
			t.recipe.encode(mut w)
		}
		CraftingEntryShaped {
			w.write_varint32(1)
			t.recipe.encode(mut w)
		}
		CraftingEntryMulti {
			w.write_varint32(4)
			t.multi_recipe.encode(mut w)
			w.write_varuint32(t.net_id)
		}
		CraftingEntryShulkerBox {
			w.write_varint32(5)
			t.recipe.encode(mut w)
		}
		CraftingEntryShapelessChemistry {
			w.write_varint32(6)
			t.recipe.encode(mut w)
		}
		CraftingEntryShapedChemistry {
			w.write_varint32(7)
			t.recipe.encode(mut w)
		}
		CraftingEntrySmithingTransform {
			w.write_varint32(8)
			t.recipe.encode(mut w)
		}
		CraftingEntrySmithingTrim {
			w.write_varint32(9)
			t.recipe.encode(mut w)
		}
	}
}

pub fn CraftingDataEntryType.decode(mut r serializer.Reader) !CraftingDataEntryType {
	d := r.read_varint32()!
	match d {
		0 {
			return CraftingEntryShapeless{
				recipe: types_685.ShapelessRecipe.decode(mut r)!
			}
		}
		1 {
			return CraftingEntryShaped{
				recipe: types_685.ShapedRecipe.decode(mut r)!
			}
		}
		4 {
			return CraftingEntryMulti{
				multi_recipe: types_662.Uuid.decode(mut r)!
				net_id:       r.read_varuint32()!
			}
		}
		5 {
			return CraftingEntryShulkerBox{
				recipe: ShulkerBoxRecipe.decode(mut r)!
			}
		}
		6 {
			return CraftingEntryShapelessChemistry{
				recipe: types_685.ShapelessRecipe.decode(mut r)!
			}
		}
		7 {
			return CraftingEntryShapedChemistry{
				recipe: types_685.ShapedRecipe.decode(mut r)!
			}
		}
		8 {
			return CraftingEntrySmithingTransform{
				recipe: types_662.SmithingTransformRecipe.decode(mut r)!
			}
		}
		9 {
			return CraftingEntrySmithingTrim{
				recipe: types_662.SmithingTrimRecipe.decode(mut r)!
			}
		}
		else {
			return error('invalid CraftingDataEntryType ${d}')
		}
	}
}
