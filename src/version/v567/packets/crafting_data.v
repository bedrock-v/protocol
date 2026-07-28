module packets

import protocol.serializer
import protocol.version.v567.types

pub struct PotionMixData {
pub mut:
	input_id     i32
	input_meta   i32
	reagent_id   i32
	reagent_meta i32
	output_id    i32
	output_meta  i32
}

pub struct ContainerMixData {
pub mut:
	input_id   i32
	reagent_id i32
	output_id  i32
}

pub struct MaterialReducerEntry {
pub mut:
	item_id i32
	count   i32
}

pub struct MaterialReducer {
pub mut:
	input_id    i32
	item_counts []MaterialReducerEntry
}

pub struct CraftingDataPacket {
pub mut:
	crafting_data      []types.RecipeData
	potion_mix_data    []PotionMixData
	container_mix_data []ContainerMixData
	material_reducers  []MaterialReducer
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
		w.write_varint32(mix.input_id)
		w.write_varint32(mix.input_meta)
		w.write_varint32(mix.reagent_id)
		w.write_varint32(mix.reagent_meta)
		w.write_varint32(mix.output_id)
		w.write_varint32(mix.output_meta)
	}
	w.write_varuint32(u32(p.container_mix_data.len))
	for mix in p.container_mix_data {
		w.write_varint32(mix.input_id)
		w.write_varint32(mix.reagent_id)
		w.write_varint32(mix.output_id)
	}
	w.write_varuint32(u32(p.material_reducers.len))
	for reducer in p.material_reducers {
		w.write_varint32(reducer.input_id)
		w.write_varuint32(u32(reducer.item_counts.len))
		for entry in reducer.item_counts {
			w.write_varint32(entry.item_id)
			w.write_varint32(entry.count)
		}
	}
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	recipe_count := int(r.read_varuint32()!)
	p.crafting_data = []types.RecipeData{cap: recipe_count}
	for _ in 0 .. recipe_count {
		p.crafting_data << types.RecipeData.decode(mut r)!
	}
	potion_count := int(r.read_varuint32()!)
	p.potion_mix_data = []PotionMixData{cap: potion_count}
	for _ in 0 .. potion_count {
		p.potion_mix_data << PotionMixData{
			input_id:     r.read_varint32()!
			input_meta:   r.read_varint32()!
			reagent_id:   r.read_varint32()!
			reagent_meta: r.read_varint32()!
			output_id:    r.read_varint32()!
			output_meta:  r.read_varint32()!
		}
	}
	container_count := int(r.read_varuint32()!)
	p.container_mix_data = []ContainerMixData{cap: container_count}
	for _ in 0 .. container_count {
		p.container_mix_data << ContainerMixData{
			input_id:   r.read_varint32()!
			reagent_id: r.read_varint32()!
			output_id:  r.read_varint32()!
		}
	}
	reducer_count := int(r.read_varuint32()!)
	p.material_reducers = []MaterialReducer{cap: reducer_count}
	for _ in 0 .. reducer_count {
		mut reducer := MaterialReducer{
			input_id: r.read_varint32()!
		}
		entry_count := int(r.read_varuint32()!)
		reducer.item_counts = []MaterialReducerEntry{cap: entry_count}
		for _ in 0 .. entry_count {
			reducer.item_counts << MaterialReducerEntry{
				item_id: r.read_varint32()!
				count:   r.read_varint32()!
			}
		}
		p.material_reducers << reducer
	}
	p.clean_recipes = r.bool()!
}
