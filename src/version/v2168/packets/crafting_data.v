module packets

import serializer
import version.v2168.types
import version.v662.types as types_662

pub struct CraftingDataPacket {
pub mut:
	shaped_recipes              []types.ShapedRecipe
	shapeless_recipes           []types.ShapelessRecipe
	multi_recipes               []types.MultiRecipe
	user_data_shapeless_recipes []types.ShapelessRecipe
	shapeless_chemistry_recipes []types.ShapelessRecipe
	shaped_chemistry_recipes    []types.ShapedRecipe
	smithing_transform_recipes  []types.SmithingTransformRecipe
	smithing_trim_recipes       []types.SmithingTrimRecipe
	potion_mixes                []types_662.PotionMixDataEntry
	container_mixes             []types_662.ContainerMixDataEntry
	material_reducers           []types_662.MaterialReducerDataEntry
	clear_recipes               bool
}

pub fn (p &CraftingDataPacket) pid() u16 { return 52 }

pub fn (p &CraftingDataPacket) name() string { return 'CraftingDataPacket' }

pub fn (p &CraftingDataPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CraftingDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shaped_recipes.len))
	for e in p.shaped_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.shapeless_recipes.len))
	for e in p.shapeless_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.multi_recipes.len))
	for e in p.multi_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.user_data_shapeless_recipes.len))
	for e in p.user_data_shapeless_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.shapeless_chemistry_recipes.len))
	for e in p.shapeless_chemistry_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.shaped_chemistry_recipes.len))
	for e in p.shaped_chemistry_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.smithing_transform_recipes.len))
	for e in p.smithing_transform_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.smithing_trim_recipes.len))
	for e in p.smithing_trim_recipes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.potion_mixes.len))
	for e in p.potion_mixes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.container_mixes.len))
	for e in p.container_mixes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.material_reducers.len))
	for e in p.material_reducers {
		e.encode(mut w)
	}
	w.bool(p.clear_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.shaped_recipes = []types.ShapedRecipe{cap: count}
		for _ in 0 .. count {
			p.shaped_recipes << types.ShapedRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.shapeless_recipes = []types.ShapelessRecipe{cap: count}
		for _ in 0 .. count {
			p.shapeless_recipes << types.ShapelessRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.multi_recipes = []types.MultiRecipe{cap: count}
		for _ in 0 .. count {
			p.multi_recipes << types.MultiRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.user_data_shapeless_recipes = []types.ShapelessRecipe{cap: count}
		for _ in 0 .. count {
			p.user_data_shapeless_recipes << types.ShapelessRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.shapeless_chemistry_recipes = []types.ShapelessRecipe{cap: count}
		for _ in 0 .. count {
			p.shapeless_chemistry_recipes << types.ShapelessRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.shaped_chemistry_recipes = []types.ShapedRecipe{cap: count}
		for _ in 0 .. count {
			p.shaped_chemistry_recipes << types.ShapedRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.smithing_transform_recipes = []types.SmithingTransformRecipe{cap: count}
		for _ in 0 .. count {
			p.smithing_transform_recipes << types.SmithingTransformRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.smithing_trim_recipes = []types.SmithingTrimRecipe{cap: count}
		for _ in 0 .. count {
			p.smithing_trim_recipes << types.SmithingTrimRecipe.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.potion_mixes = []types_662.PotionMixDataEntry{cap: count}
		for _ in 0 .. count {
			p.potion_mixes << types_662.PotionMixDataEntry.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.container_mixes = []types_662.ContainerMixDataEntry{cap: count}
		for _ in 0 .. count {
			p.container_mixes << types_662.ContainerMixDataEntry.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.material_reducers = []types_662.MaterialReducerDataEntry{cap: count}
		for _ in 0 .. count {
			p.material_reducers << types_662.MaterialReducerDataEntry.decode(mut r)!
		}
	}
	p.clear_recipes = r.bool()!
}
