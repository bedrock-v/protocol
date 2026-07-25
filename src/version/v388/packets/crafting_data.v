module packets

import serializer
import version.v361.types as types_361
import version.v388.types

pub struct CraftingDataPacket {
pub mut:
	crafting_data      []types_361.RecipeData
	potion_mix_data    []types.PotionMixData
	container_mix_data []types.ContainerMixData
	clean_recipes      bool
}

pub fn (p &CraftingDataPacket) pid() u16 {
	return 52
}

pub fn (p &CraftingDataPacket) name() string {
	return 'CraftingDataPacket'
}

pub fn (p &CraftingDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.crafting_data.len))
	for entry in p.crafting_data {
		entry.encode(mut w)
	}
	w.write_varuint32(u32(p.potion_mix_data.len))
	for entry in p.potion_mix_data {
		entry.encode(mut w)
	}
	w.write_varuint32(u32(p.container_mix_data.len))
	for entry in p.container_mix_data {
		entry.encode(mut w)
	}
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	recipe_count := int(r.read_varuint32()!)
	p.crafting_data = []types_361.RecipeData{cap: recipe_count}
	for _ in 0 .. recipe_count {
		p.crafting_data << types_361.RecipeData.decode(mut r)!
	}
	potion_mix_count := int(r.read_varuint32()!)
	p.potion_mix_data = []types.PotionMixData{cap: potion_mix_count}
	for _ in 0 .. potion_mix_count {
		p.potion_mix_data << types.PotionMixData.decode(mut r)!
	}
	container_mix_count := int(r.read_varuint32()!)
	p.container_mix_data = []types.ContainerMixData{cap: container_mix_count}
	for _ in 0 .. container_mix_count {
		p.container_mix_data << types.ContainerMixData.decode(mut r)!
	}
	p.clean_recipes = r.bool()!
}
