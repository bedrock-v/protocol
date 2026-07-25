module types

import serializer
import version.v291.types as types_291

pub const crafting_data_type_shapeless = i32(0)
pub const crafting_data_type_shaped = i32(1)
pub const crafting_data_type_furnace = i32(2)
pub const crafting_data_type_furnace_data = i32(3)
pub const crafting_data_type_multi = i32(4)
pub const crafting_data_type_shulker_box = i32(5)
pub const crafting_data_type_shapeless_chemistry = i32(6)
pub const crafting_data_type_shaped_chemistry = i32(7)

pub struct ShapelessRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shapeless
	inputs      []ItemData
	outputs     []ItemData
	uuid        types_291.Uuid
}

pub struct ShapedRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shaped
	width       i32
	height      i32
	inputs      []ItemData
	outputs     []ItemData
	uuid        types_291.Uuid
}

pub struct FurnaceRecipeData {
pub mut:
	recipe_type  i32 = crafting_data_type_furnace
	input_id     i32
	input_damage i32 = -1
	result       ItemData
}

pub struct MultiRecipeData {
pub mut:
	uuid types_291.Uuid
}

pub type RecipeData = FurnaceRecipeData
	| MultiRecipeData
	| ShapedRecipeData
	| ShapelessRecipeData

pub fn (t RecipeData) encode(mut w serializer.Writer) {
	match t {
		ShapelessRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_varuint32(u32(t.inputs.len))
			for input in t.inputs {
				input.encode(mut w)
			}
			w.write_varuint32(u32(t.outputs.len))
			for output in t.outputs {
				output.encode(mut w)
			}
			t.uuid.encode(mut w)
		}
		ShapedRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_varint32(t.width)
			w.write_varint32(t.height)
			count := int(t.width * t.height)
			for i in 0 .. count {
				t.inputs[i].encode(mut w)
			}
			w.write_varuint32(u32(t.outputs.len))
			for output in t.outputs {
				output.encode(mut w)
			}
			t.uuid.encode(mut w)
		}
		FurnaceRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_varint32(t.input_id)
			if t.recipe_type == crafting_data_type_furnace_data {
				w.write_varint32(t.input_damage)
			}
			t.result.encode(mut w)
		}
		MultiRecipeData {
			w.write_varint32(crafting_data_type_multi)
			t.uuid.encode(mut w)
		}
	}
}

pub fn RecipeData.decode(mut r serializer.Reader) !RecipeData {
	recipe_type := r.read_varint32()!
	match recipe_type {
		crafting_data_type_shapeless, crafting_data_type_shulker_box,
		crafting_data_type_shapeless_chemistry {
			mut t := ShapelessRecipeData{
				recipe_type: recipe_type
			}
			input_count := int(r.read_varuint32()!)
			t.inputs = []ItemData{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << ItemData.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << ItemData.decode(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			return t
		}
		crafting_data_type_shaped, crafting_data_type_shaped_chemistry {
			mut t := ShapedRecipeData{
				recipe_type: recipe_type
			}
			t.width = r.read_varint32()!
			t.height = r.read_varint32()!
			input_count := int(t.width * t.height)
			t.inputs = []ItemData{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << ItemData.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << ItemData.decode(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			return t
		}
		crafting_data_type_furnace, crafting_data_type_furnace_data {
			mut t := FurnaceRecipeData{
				recipe_type: recipe_type
			}
			t.input_id = r.read_varint32()!
			if recipe_type == crafting_data_type_furnace_data {
				t.input_damage = r.read_varint32()!
			}
			t.result = ItemData.decode(mut r)!
			return t
		}
		crafting_data_type_multi {
			return MultiRecipeData{
				uuid: types_291.Uuid.decode(mut r)!
			}
		}
		else {
			return error('invalid RecipeData type ${recipe_type}')
		}
	}
}
