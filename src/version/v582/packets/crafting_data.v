module packets

import protocol.serializer
import protocol.version.v388.types as types_388
import protocol.version.v407.types as types_407
import protocol.version.v465.types as types_465
import protocol.version.v582.types

pub struct CraftingDataPacket {
pub mut:
	crafting_data      []types.RecipeData
	potion_mix_data    []types_407.PotionMixData
	container_mix_data []types_388.ContainerMixData
	material_reducers  []types_465.MaterialReducer
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
	for mix in p.potion_mix_data {
		mix.encode(mut w)
	}
	w.write_varuint32(u32(p.container_mix_data.len))
	for mix in p.container_mix_data {
		mix.encode(mut w)
	}
	w.write_varuint32(u32(p.material_reducers.len))
	for reducer in p.material_reducers {
		reducer.encode(mut w)
	}
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	entry_count := int(r.read_varuint32()!)
	p.crafting_data = []types.RecipeData{cap: entry_count}
	for _ in 0 .. entry_count {
		p.crafting_data << types.RecipeData.decode(mut r)!
	}
	potion_mix_count := int(r.read_varuint32()!)
	p.potion_mix_data = []types_407.PotionMixData{cap: potion_mix_count}
	for _ in 0 .. potion_mix_count {
		p.potion_mix_data << types_407.PotionMixData.decode(mut r)!
	}
	container_mix_count := int(r.read_varuint32()!)
	p.container_mix_data = []types_388.ContainerMixData{cap: container_mix_count}
	for _ in 0 .. container_mix_count {
		p.container_mix_data << types_388.ContainerMixData.decode(mut r)!
	}
	reducer_count := int(r.read_varuint32()!)
	p.material_reducers = []types_465.MaterialReducer{cap: reducer_count}
	for _ in 0 .. reducer_count {
		p.material_reducers << types_465.MaterialReducer.decode(mut r)!
	}
	p.clean_recipes = r.bool()!
}
