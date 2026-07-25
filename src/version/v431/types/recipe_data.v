module types

import serializer
import version.v291.types as types_291
import version.v407.types as types_407

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
	recipe_id   string
	ingredients []types_407.Ingredient
	results     []ItemData
	uuid        types_291.Uuid
	tag         string
	priority    i32
	network_id  u32
}

pub struct ShapedRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shaped
	recipe_id   string
	width       i32
	height      i32
	ingredients []types_407.Ingredient
	results     []ItemData
	uuid        types_291.Uuid
	tag         string
	priority    i32
	network_id  u32
}

pub struct FurnaceRecipeData {
pub mut:
	recipe_type  i32 = crafting_data_type_furnace
	input_id     i32
	input_damage i32 = -1
	result       ItemData
	tag          string
}

pub struct MultiRecipeData {
pub mut:
	uuid       types_291.Uuid
	network_id u32
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
			w.write_varuint32(u32(t.ingredients.len))
			for ingredient in t.ingredients {
				ingredient.encode(mut w)
			}
			w.write_varuint32(u32(t.results.len))
			for result in t.results {
				result.encode_instance(mut w)
			}
			t.uuid.encode(mut w)
			w.write_string(t.tag)
			w.write_varint32(t.priority)
			w.write_varuint32(t.network_id)
		}
		ShapedRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_string(t.recipe_id)
			w.write_varint32(t.width)
			w.write_varint32(t.height)
			for ingredient in t.ingredients {
				ingredient.encode(mut w)
			}
			w.write_varuint32(u32(t.results.len))
			for result in t.results {
				result.encode_instance(mut w)
			}
			t.uuid.encode(mut w)
			w.write_string(t.tag)
			w.write_varint32(t.priority)
			w.write_varuint32(t.network_id)
		}
		FurnaceRecipeData {
			w.write_varint32(t.recipe_type)
			w.write_varint32(t.input_id)
			if t.recipe_type == crafting_data_type_furnace_data {
				w.write_varint32(t.input_damage)
			}
			t.result.encode_instance(mut w)
			w.write_string(t.tag)
		}
		MultiRecipeData {
			w.write_varint32(crafting_data_type_multi)
			t.uuid.encode(mut w)
			w.write_varuint32(t.network_id)
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
			ingredient_count := int(r.read_varuint32()!)
			t.ingredients = []types_407.Ingredient{cap: ingredient_count}
			for _ in 0 .. ingredient_count {
				t.ingredients << types_407.Ingredient.decode(mut r)!
			}
			result_count := int(r.read_varuint32()!)
			t.results = []ItemData{cap: result_count}
			for _ in 0 .. result_count {
				t.results << ItemData.decode_instance(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			t.tag = r.read_string()!
			t.priority = r.read_varint32()!
			t.network_id = r.read_varuint32()!
			return t
		}
		crafting_data_type_shaped, crafting_data_type_shaped_chemistry {
			mut t := ShapedRecipeData{
				recipe_type: recipe_type
			}
			t.recipe_id = r.read_string()!
			t.width = r.read_varint32()!
			t.height = r.read_varint32()!
			ingredient_count := int(t.width * t.height)
			t.ingredients = []types_407.Ingredient{cap: ingredient_count}
			for _ in 0 .. ingredient_count {
				t.ingredients << types_407.Ingredient.decode(mut r)!
			}
			result_count := int(r.read_varuint32()!)
			t.results = []ItemData{cap: result_count}
			for _ in 0 .. result_count {
				t.results << ItemData.decode_instance(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			t.tag = r.read_string()!
			t.priority = r.read_varint32()!
			t.network_id = r.read_varuint32()!
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
			t.result = ItemData.decode_instance(mut r)!
			t.tag = r.read_string()!
			return t
		}
		crafting_data_type_multi {
			return MultiRecipeData{
				uuid:       types_291.Uuid.decode(mut r)!
				network_id: r.read_varuint32()!
			}
		}
		else {
			return error('invalid crafting data type ${recipe_type}')
		}
	}
}

pub struct PotionMixData {
pub mut:
	input_id     i32
	input_meta   i32
	reagent_id   i32
	reagent_meta i32
	output_id    i32
	output_meta  i32
}

pub fn (t PotionMixData) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_id)
	w.write_varint32(t.input_meta)
	w.write_varint32(t.reagent_id)
	w.write_varint32(t.reagent_meta)
	w.write_varint32(t.output_id)
	w.write_varint32(t.output_meta)
}

pub fn PotionMixData.decode(mut r serializer.Reader) !PotionMixData {
	return PotionMixData{
		input_id:     r.read_varint32()!
		input_meta:   r.read_varint32()!
		reagent_id:   r.read_varint32()!
		reagent_meta: r.read_varint32()!
		output_id:    r.read_varint32()!
		output_meta:  r.read_varint32()!
	}
}

pub struct ContainerMixData {
pub mut:
	input_id   i32
	reagent_id i32
	output_id  i32
}

pub fn (t ContainerMixData) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_id)
	w.write_varint32(t.reagent_id)
	w.write_varint32(t.output_id)
}

pub fn ContainerMixData.decode(mut r serializer.Reader) !ContainerMixData {
	return ContainerMixData{
		input_id:   r.read_varint32()!
		reagent_id: r.read_varint32()!
		output_id:  r.read_varint32()!
	}
}
