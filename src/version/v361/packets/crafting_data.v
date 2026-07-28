module packets

import protocol.serializer
import protocol.version.v361.types

pub struct CraftingDataPacket {
pub mut:
	crafting_data []types.RecipeData
	clean_recipes bool
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
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.crafting_data = []types.RecipeData{cap: count}
	for _ in 0 .. count {
		p.crafting_data << types.RecipeData.decode(mut r)!
	}
	p.clean_recipes = r.bool()!
}
