module types

import serializer
import version.v291.types as types_291
import version.v340.types as types_340

pub const crafting_data_type_shapeless = i32(0)
pub const crafting_data_type_shaped = i32(1)
pub const crafting_data_type_furnace = i32(2)
pub const crafting_data_type_furnace_data = i32(3)
pub const crafting_data_type_multi = i32(4)
pub const crafting_data_type_shulker_box = i32(5)
pub const crafting_data_type_shapeless_chemistry = i32(6)
pub const crafting_data_type_shaped_chemistry = i32(7)

pub struct RecipeIngredient {
pub mut:
	runtime_id i32
	aux_value  i32
	count      i32
}

pub fn (t RecipeIngredient) encode(mut w serializer.Writer) {
	w.write_varint32(t.runtime_id)
	if t.runtime_id != 0 {
		aux := if t.aux_value == -1 { i32(0x7fff) } else { t.aux_value }
		w.write_varint32(aux)
		w.write_varint32(t.count)
	}
}

pub fn RecipeIngredient.decode(mut r serializer.Reader) !RecipeIngredient {
	mut t := RecipeIngredient{}
	t.runtime_id = r.read_varint32()!
	if t.runtime_id != 0 {
		aux := r.read_varint32()!
		t.aux_value = if aux == 0x7fff { i32(-1) } else { aux }
		t.count = r.read_varint32()!
	}
	return t
}

pub struct ShapelessRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shapeless
	recipe_id   string
	inputs      []RecipeIngredient
	outputs     []types_340.ItemData
	uuid        types_291.Uuid
	tag         string
	priority    i32
}

pub struct ShapedRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shaped
	recipe_id   string
	width       i32
	height      i32
	inputs      []RecipeIngredient
	outputs     []types_340.ItemData
	uuid        types_291.Uuid
	tag         string
	priority    i32
}

pub struct FurnaceRecipeData {
pub mut:
	recipe_type  i32 = crafting_data_type_furnace
	input_id     i32
	input_damage i32 = -1
	result       types_340.ItemData
	tag          string
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
			w.write_string(t.recipe_id)
			w.write_varuint32(u32(t.inputs.len))
			for input in t.inputs {
				input.encode(mut w)
			}
			w.write_varuint32(u32(t.outputs.len))
			for output in t.outputs {
				output.encode(mut w)
			}
			t.uuid.encode(mut w)
			w.write_string(t.tag)
			w.write_varint32(t.priority)
		}
		ShapedRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_string(t.recipe_id)
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
			w.write_string(t.tag)
			w.write_varint32(t.priority)
		}
		FurnaceRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_varint32(t.input_id)
			if t.recipe_type == crafting_data_type_furnace_data {
				w.write_varint32(t.input_damage)
			}
			t.result.encode(mut w)
			w.write_string(t.tag)
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
			t.recipe_id = r.read_string()!
			input_count := int(r.read_varuint32()!)
			t.inputs = []RecipeIngredient{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << RecipeIngredient.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []types_340.ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << types_340.ItemData.decode(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			t.tag = r.read_string()!
			t.priority = r.read_varint32()!
			return t
		}
		crafting_data_type_shaped, crafting_data_type_shaped_chemistry {
			mut t := ShapedRecipeData{
				recipe_type: recipe_type
			}
			t.recipe_id = r.read_string()!
			t.width = r.read_varint32()!
			t.height = r.read_varint32()!
			input_count := int(t.width * t.height)
			t.inputs = []RecipeIngredient{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << RecipeIngredient.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []types_340.ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << types_340.ItemData.decode(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			t.tag = r.read_string()!
			t.priority = r.read_varint32()!
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
			t.result = types_340.ItemData.decode(mut r)!
			t.tag = r.read_string()!
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
