module src

import src.serializer
import src.types

pub const recipe_shapeless = 0
pub const recipe_shaped = 1
pub const recipe_multi = 4
pub const recipe_shulker_box = 5
pub const recipe_shapeless_chemistry = 6
pub const recipe_shaped_chemistry = 7
pub const recipe_smithing_transform = 8
pub const recipe_smithing_trim = 9

pub const recipe_unlock_context_none = u8(0)

pub struct RecipeUnlockRequirement {
pub mut:
	context     u8
	ingredients []types.ItemDescriptorCount
}

pub struct Recipe {
pub mut:
	recipe_type        int
	recipe_id          string
	width              int
	height             int
	input              []types.ItemDescriptorCount
	output             []types.ItemStack
	uuid               types.UUID
	block              string
	priority           int
	assume_symmetry    bool
	unlock_requirement RecipeUnlockRequirement
	recipe_network_id  u32
	template           types.ItemDescriptorCount
	base               types.ItemDescriptorCount
	addition           types.ItemDescriptorCount
	result             types.ItemStack
}

pub struct PotionRecipe {
pub mut:
	input_potion_id       int
	input_potion_metadata int
	reagent_item_id       int
	reagent_item_metadata int
	output_potion_id      int
	output_potion_metadata int
}

pub struct PotionContainerChangeRecipe {
pub mut:
	input_item_id   int
	reagent_item_id int
	output_item_id  int
}

pub struct MaterialReducerOutput {
pub mut:
	network_id int
	count      int
}

pub struct MaterialReducer {
pub mut:
	input_mix int
	outputs   []MaterialReducerOutput
}

pub struct CraftingDataPacket {
pub mut:
	recipes                         []Recipe
	potion_recipes                  []PotionRecipe
	potion_container_change_recipes []PotionContainerChangeRecipe
	material_reducers               []MaterialReducer
	clear_recipes                   bool
}

pub fn (p &CraftingDataPacket) pid() u16 {
	return crafting_data_packet
}

pub fn (p &CraftingDataPacket) name() string {
	return 'CraftingDataPacket'
}

pub fn (p &CraftingDataPacket) can_be_sent_before_login() bool {
	return false
}

fn read_recipe_unlock_requirement(mut r serializer.Reader) !RecipeUnlockRequirement {
	mut u := RecipeUnlockRequirement{
		context: r.u8()!
	}
	if u.context == recipe_unlock_context_none {
		count := r.read_varuint32()!
		u.ingredients = []types.ItemDescriptorCount{}
		for _ in 0 .. count {
			u.ingredients << r.read_item_descriptor_count()!
		}
	}
	return u
}

fn write_recipe_unlock_requirement(mut w serializer.Writer, u RecipeUnlockRequirement) {
	w.u8(u.context)
	if u.context == recipe_unlock_context_none {
		w.write_varuint32(u32(u.ingredients.len))
		for ing in u.ingredients {
			w.write_item_descriptor_count(ing)
		}
	}
}

fn read_descriptor_list(mut r serializer.Reader) ![]types.ItemDescriptorCount {
	count := r.read_varuint32()!
	mut out := []types.ItemDescriptorCount{}
	for _ in 0 .. count {
		out << r.read_item_descriptor_count()!
	}
	return out
}

fn read_recipe_output(mut r serializer.Reader) ![]types.ItemStack {
	count := r.read_varuint32()!
	mut out := []types.ItemStack{}
	for _ in 0 .. count {
		out << r.read_item_stack_without_stack_id()!
	}
	return out
}

fn write_recipe_output(mut w serializer.Writer, out []types.ItemStack) {
	w.write_varuint32(u32(out.len))
	for item in out {
		w.write_item_stack_without_stack_id(item)
	}
}

fn read_recipe(mut r serializer.Reader) !Recipe {
	mut rec := Recipe{
		recipe_type: r.read_varint32()!
	}
	match rec.recipe_type {
		recipe_shapeless, recipe_shulker_box, recipe_shapeless_chemistry {
			rec.recipe_id = r.read_string()!
			rec.input = read_descriptor_list(mut r)!
			rec.output = read_recipe_output(mut r)!
			rec.uuid = r.read_uuid()!
			rec.block = r.read_string()!
			rec.priority = r.read_varint32()!
			rec.unlock_requirement = read_recipe_unlock_requirement(mut r)!
			rec.recipe_network_id = r.read_varuint32()!
		}
		recipe_shaped, recipe_shaped_chemistry {
			rec.recipe_id = r.read_string()!
			rec.width = r.read_varint32()!
			rec.height = r.read_varint32()!
			rec.input = []types.ItemDescriptorCount{}
			for _ in 0 .. rec.width * rec.height {
				rec.input << r.read_item_descriptor_count()!
			}
			rec.output = read_recipe_output(mut r)!
			rec.uuid = r.read_uuid()!
			rec.block = r.read_string()!
			rec.priority = r.read_varint32()!
			rec.assume_symmetry = r.bool()!
			rec.unlock_requirement = read_recipe_unlock_requirement(mut r)!
			rec.recipe_network_id = r.read_varuint32()!
		}
		recipe_multi {
			rec.uuid = r.read_uuid()!
			rec.recipe_network_id = r.read_varuint32()!
		}
		recipe_smithing_transform {
			rec.recipe_id = r.read_string()!
			rec.template = r.read_item_descriptor_count()!
			rec.base = r.read_item_descriptor_count()!
			rec.addition = r.read_item_descriptor_count()!
			rec.result = r.read_item_stack_without_stack_id()!
			rec.block = r.read_string()!
			rec.recipe_network_id = r.read_varuint32()!
		}
		recipe_smithing_trim {
			rec.recipe_id = r.read_string()!
			rec.template = r.read_item_descriptor_count()!
			rec.base = r.read_item_descriptor_count()!
			rec.addition = r.read_item_descriptor_count()!
			rec.block = r.read_string()!
			rec.recipe_network_id = r.read_varuint32()!
		}
		else {}
	}
	return rec
}

fn write_recipe(mut w serializer.Writer, rec Recipe) {
	w.write_varint32(rec.recipe_type)
	match rec.recipe_type {
		recipe_shapeless, recipe_shulker_box, recipe_shapeless_chemistry {
			w.write_string(rec.recipe_id)
			w.write_varuint32(u32(rec.input.len))
			for ing in rec.input {
				w.write_item_descriptor_count(ing)
			}
			write_recipe_output(mut w, rec.output)
			w.write_uuid(rec.uuid)
			w.write_string(rec.block)
			w.write_varint32(rec.priority)
			write_recipe_unlock_requirement(mut w, rec.unlock_requirement)
			w.write_varuint32(rec.recipe_network_id)
		}
		recipe_shaped, recipe_shaped_chemistry {
			w.write_string(rec.recipe_id)
			w.write_varint32(rec.width)
			w.write_varint32(rec.height)
			for ing in rec.input {
				w.write_item_descriptor_count(ing)
			}
			write_recipe_output(mut w, rec.output)
			w.write_uuid(rec.uuid)
			w.write_string(rec.block)
			w.write_varint32(rec.priority)
			w.bool(rec.assume_symmetry)
			write_recipe_unlock_requirement(mut w, rec.unlock_requirement)
			w.write_varuint32(rec.recipe_network_id)
		}
		recipe_multi {
			w.write_uuid(rec.uuid)
			w.write_varuint32(rec.recipe_network_id)
		}
		recipe_smithing_transform {
			w.write_string(rec.recipe_id)
			w.write_item_descriptor_count(rec.template)
			w.write_item_descriptor_count(rec.base)
			w.write_item_descriptor_count(rec.addition)
			w.write_item_stack_without_stack_id(rec.result)
			w.write_string(rec.block)
			w.write_varuint32(rec.recipe_network_id)
		}
		recipe_smithing_trim {
			w.write_string(rec.recipe_id)
			w.write_item_descriptor_count(rec.template)
			w.write_item_descriptor_count(rec.base)
			w.write_item_descriptor_count(rec.addition)
			w.write_string(rec.block)
			w.write_varuint32(rec.recipe_network_id)
		}
		else {}
	}
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	recipe_count := r.read_varuint32()!
	p.recipes = []Recipe{}
	for _ in 0 .. recipe_count {
		p.recipes << read_recipe(mut r)!
	}
	potion_count := r.read_varuint32()!
	p.potion_recipes = []PotionRecipe{}
	for _ in 0 .. potion_count {
		p.potion_recipes << PotionRecipe{
			input_potion_id:        r.read_varint32()!
			input_potion_metadata:  r.read_varint32()!
			reagent_item_id:        r.read_varint32()!
			reagent_item_metadata:  r.read_varint32()!
			output_potion_id:       r.read_varint32()!
			output_potion_metadata: r.read_varint32()!
		}
	}
	container_count := r.read_varuint32()!
	p.potion_container_change_recipes = []PotionContainerChangeRecipe{}
	for _ in 0 .. container_count {
		p.potion_container_change_recipes << PotionContainerChangeRecipe{
			input_item_id:   r.read_varint32()!
			reagent_item_id: r.read_varint32()!
			output_item_id:  r.read_varint32()!
		}
	}
	reducer_count := r.read_varuint32()!
	p.material_reducers = []MaterialReducer{}
	for _ in 0 .. reducer_count {
		mut m := MaterialReducer{
			input_mix: r.read_varint32()!
		}
		out_count := r.read_varuint32()!
		m.outputs = []MaterialReducerOutput{}
		for _ in 0 .. out_count {
			m.outputs << MaterialReducerOutput{
				network_id: r.read_varint32()!
				count:      r.read_varint32()!
			}
		}
		p.material_reducers << m
	}
	p.clear_recipes = r.bool()!
}

pub fn (p &CraftingDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.recipes.len))
	for rec in p.recipes {
		write_recipe(mut w, rec)
	}
	w.write_varuint32(u32(p.potion_recipes.len))
	for pr in p.potion_recipes {
		w.write_varint32(pr.input_potion_id)
		w.write_varint32(pr.input_potion_metadata)
		w.write_varint32(pr.reagent_item_id)
		w.write_varint32(pr.reagent_item_metadata)
		w.write_varint32(pr.output_potion_id)
		w.write_varint32(pr.output_potion_metadata)
	}
	w.write_varuint32(u32(p.potion_container_change_recipes.len))
	for cc in p.potion_container_change_recipes {
		w.write_varint32(cc.input_item_id)
		w.write_varint32(cc.reagent_item_id)
		w.write_varint32(cc.output_item_id)
	}
	w.write_varuint32(u32(p.material_reducers.len))
	for m in p.material_reducers {
		w.write_varint32(m.input_mix)
		w.write_varuint32(u32(m.outputs.len))
		for o in m.outputs {
			w.write_varint32(o.network_id)
			w.write_varint32(o.count)
		}
	}
	w.bool(p.clear_recipes)
}
