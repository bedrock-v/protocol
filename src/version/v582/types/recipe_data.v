module types

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v431.types as types_431
import protocol.version.v575.types as types_575

pub const crafting_data_type_shapeless = i32(0)
pub const crafting_data_type_shaped = i32(1)
pub const crafting_data_type_furnace = i32(2)
pub const crafting_data_type_furnace_data = i32(3)
pub const crafting_data_type_multi = i32(4)
pub const crafting_data_type_shulker_box = i32(5)
pub const crafting_data_type_shapeless_chemistry = i32(6)
pub const crafting_data_type_shaped_chemistry = i32(7)
pub const crafting_data_type_smithing_transform = i32(8)
pub const crafting_data_type_smithing_trim = i32(9)

pub struct ShapelessRecipeData {
pub mut:
	recipe_type i32 = crafting_data_type_shapeless
	recipe_id   string
	inputs      []types_575.ItemDescriptorWithCount
	outputs     []types_431.ItemData
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
	inputs      []types_575.ItemDescriptorWithCount
	outputs     []types_431.ItemData
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
	result       types_431.ItemData
	tag          string
}

pub struct MultiRecipeData {
pub mut:
	uuid       types_291.Uuid
	network_id u32
}

pub struct SmithingTransformRecipeData {
pub mut:
	recipe_id  string
	template   types_575.ItemDescriptorWithCount
	base       types_575.ItemDescriptorWithCount
	addition   types_575.ItemDescriptorWithCount
	result     types_431.ItemData
	tag        string
	network_id u32
}

pub struct SmithingTrimRecipeData {
pub mut:
	recipe_id  string
	template   types_575.ItemDescriptorWithCount
	base       types_575.ItemDescriptorWithCount
	addition   types_575.ItemDescriptorWithCount
	tag        string
	network_id u32
}

pub type RecipeData = FurnaceRecipeData
	| MultiRecipeData
	| ShapedRecipeData
	| ShapelessRecipeData
	| SmithingTransformRecipeData
	| SmithingTrimRecipeData

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
				output.encode_instance(mut w)
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
			count := int(t.width * t.height)
			for i in 0 .. count {
				t.inputs[i].encode(mut w)
			}
			w.write_varuint32(u32(t.outputs.len))
			for output in t.outputs {
				output.encode_instance(mut w)
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
		SmithingTransformRecipeData {
			w.write_varint32(crafting_data_type_smithing_transform)
			w.write_string(t.recipe_id)
			t.template.encode(mut w)
			t.base.encode(mut w)
			t.addition.encode(mut w)
			t.result.encode_instance(mut w)
			w.write_string(t.tag)
			w.write_varuint32(t.network_id)
		}
		SmithingTrimRecipeData {
			w.write_varint32(crafting_data_type_smithing_trim)
			w.write_string(t.recipe_id)
			t.template.encode(mut w)
			t.base.encode(mut w)
			t.addition.encode(mut w)
			w.write_string(t.tag)
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
			input_count := int(r.read_varuint32()!)
			t.inputs = []types_575.ItemDescriptorWithCount{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << types_575.ItemDescriptorWithCount.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []types_431.ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << types_431.ItemData.decode_instance(mut r)!
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
			input_count := int(t.width * t.height)
			t.inputs = []types_575.ItemDescriptorWithCount{cap: input_count}
			for _ in 0 .. input_count {
				t.inputs << types_575.ItemDescriptorWithCount.decode(mut r)!
			}
			output_count := int(r.read_varuint32()!)
			t.outputs = []types_431.ItemData{cap: output_count}
			for _ in 0 .. output_count {
				t.outputs << types_431.ItemData.decode_instance(mut r)!
			}
			t.uuid = types_291.Uuid.decode(mut r)!
			t.tag = r.read_string()!
			t.priority = r.read_varint32()!
			t.network_id = r.read_varuint32()!
			return t
		}
		crafting_data_type_furnace {
			return FurnaceRecipeData{
				recipe_type: recipe_type
				input_id:    r.read_varint32()!
				result:      types_431.ItemData.decode_instance(mut r)!
				tag:         r.read_string()!
			}
		}
		crafting_data_type_furnace_data {
			return FurnaceRecipeData{
				recipe_type:  recipe_type
				input_id:     r.read_varint32()!
				input_damage: r.read_varint32()!
				result:       types_431.ItemData.decode_instance(mut r)!
				tag:          r.read_string()!
			}
		}
		crafting_data_type_multi {
			return MultiRecipeData{
				uuid:       types_291.Uuid.decode(mut r)!
				network_id: r.read_varuint32()!
			}
		}
		crafting_data_type_smithing_transform {
			return SmithingTransformRecipeData{
				recipe_id:  r.read_string()!
				template:   types_575.ItemDescriptorWithCount.decode(mut r)!
				base:       types_575.ItemDescriptorWithCount.decode(mut r)!
				addition:   types_575.ItemDescriptorWithCount.decode(mut r)!
				result:     types_431.ItemData.decode_instance(mut r)!
				tag:        r.read_string()!
				network_id: r.read_varuint32()!
			}
		}
		crafting_data_type_smithing_trim {
			return SmithingTrimRecipeData{
				recipe_id:  r.read_string()!
				template:   types_575.ItemDescriptorWithCount.decode(mut r)!
				base:       types_575.ItemDescriptorWithCount.decode(mut r)!
				addition:   types_575.ItemDescriptorWithCount.decode(mut r)!
				tag:        r.read_string()!
				network_id: r.read_varuint32()!
			}
		}
		else {
			return error('unhandled crafting data type: ${recipe_type}')
		}
	}
}
