module packets

import protocol.serializer
import protocol.version.v465.types
import protocol.version.v407.types as types_407
import protocol.version.v431.types as types_431

pub struct CraftingDataPacket {
pub mut:
	crafting_data      []types_431.RecipeData
	potion_mix_data    []types_407.PotionMixData
	container_mix_data []types_407.ContainerMixData
	material_reducers  []types.MaterialReducer
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
	w.write_varuint32(u32(p.material_reducers.len))
	for entry in p.material_reducers {
		entry.encode(mut w)
	}
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	recipe_count := int(r.read_varuint32()!)
	p.crafting_data = []types_431.RecipeData{cap: recipe_count}
	for _ in 0 .. recipe_count {
		p.crafting_data << types_431.RecipeData.decode(mut r)!
	}
	potion_count := int(r.read_varuint32()!)
	p.potion_mix_data = []types_407.PotionMixData{cap: potion_count}
	for _ in 0 .. potion_count {
		p.potion_mix_data << types_407.PotionMixData.decode(mut r)!
	}
	container_count := int(r.read_varuint32()!)
	p.container_mix_data = []types_407.ContainerMixData{cap: container_count}
	for _ in 0 .. container_count {
		p.container_mix_data << types_407.ContainerMixData.decode(mut r)!
	}
	reducer_count := int(r.read_varuint32()!)
	p.material_reducers = []types.MaterialReducer{cap: reducer_count}
	for _ in 0 .. reducer_count {
		p.material_reducers << types.MaterialReducer.decode(mut r)!
	}
	p.clean_recipes = r.bool()!
}
