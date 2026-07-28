module packets

import protocol.serializer
import protocol.version.v685.types
import protocol.version.v662.types as types_662

pub struct CraftingDataPacket {
pub mut:
	crafting_entries  []types.CraftingDataEntry
	potion_mixes      []types_662.PotionMixDataEntry
	container_mixes   []types_662.ContainerMixDataEntry
	material_reducers []types_662.MaterialReducerDataEntry
	clear_recipes     bool
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
	w.write_varuint32(u32(p.crafting_entries.len))
	for e in p.crafting_entries {
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
		p.crafting_entries = []types.CraftingDataEntry{cap: count}
		for _ in 0 .. count {
			p.crafting_entries << types.CraftingDataEntry.decode(mut r)!
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
