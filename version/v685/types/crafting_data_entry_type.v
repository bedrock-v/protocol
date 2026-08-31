module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct CraftingEntryShapeless {
pub mut:
	recipe ShapelessRecipe
}

pub struct CraftingEntryShaped {
pub mut:
	recipe ShapedRecipe
}

pub struct CraftingEntryFurnace {
pub mut:
	item_data   i32
	result_item types_662.NetworkItemInstanceDescriptor
	recipe_tag  string
}

pub struct CraftingEntryFurnaceAux {
pub mut:
	item_data           i32
	auxiliary_item_data i32
	result_item         types_662.NetworkItemInstanceDescriptor
	recipe_tag          string
}

pub struct CraftingEntryMulti {
pub mut:
	multi_recipe types_662.Uuid
	net_id       u32
}

pub struct CraftingEntryShulkerBox {
pub mut:
	recipe types_662.ShulkerBoxRecipe
}

pub struct CraftingEntryShapelessChemistry {
pub mut:
	recipe ShapelessRecipe
}

pub struct CraftingEntryShapedChemistry {
pub mut:
	recipe ShapedRecipe
}

pub struct CraftingEntrySmithingTransform {
pub mut:
	recipe types_662.SmithingTransformRecipe
}

pub struct CraftingEntrySmithingTrim {
pub mut:
	recipe types_662.SmithingTrimRecipe
}

pub type CraftingDataEntryType = CraftingEntryFurnace
	| CraftingEntryFurnaceAux
	| CraftingEntryMulti
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
		CraftingEntryFurnace {
			w.write_varint32(2)
			w.write_varint32(t.item_data)
			t.result_item.encode(mut w)
			w.write_string(t.recipe_tag)
		}
		CraftingEntryFurnaceAux {
			w.write_varint32(3)
			w.write_varint32(t.item_data)
			w.write_varint32(t.auxiliary_item_data)
			t.result_item.encode(mut w)
			w.write_string(t.recipe_tag)
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
				recipe: ShapelessRecipe.decode(mut r)!
			}
		}
		1 {
			return CraftingEntryShaped{
				recipe: ShapedRecipe.decode(mut r)!
			}
		}
		2 {
			return CraftingEntryFurnace{
				item_data:   r.read_varint32()!
				result_item: types_662.NetworkItemInstanceDescriptor.decode(mut r)!
				recipe_tag:  r.read_string()!
			}
		}
		3 {
			return CraftingEntryFurnaceAux{
				item_data:           r.read_varint32()!
				auxiliary_item_data: r.read_varint32()!
				result_item:         types_662.NetworkItemInstanceDescriptor.decode(mut r)!
				recipe_tag:          r.read_string()!
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
				recipe: types_662.ShulkerBoxRecipe.decode(mut r)!
			}
		}
		6 {
			return CraftingEntryShapelessChemistry{
				recipe: ShapelessRecipe.decode(mut r)!
			}
		}
		7 {
			return CraftingEntryShapedChemistry{
				recipe: ShapedRecipe.decode(mut r)!
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
