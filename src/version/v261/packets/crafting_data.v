module packets

import serializer
import version.v137.types

pub struct CraftingDataEntry {
pub mut:
	recipe_type    i32
	input          []types.ItemData
	output         []types.ItemData
	uuid           types.Uuid
	width          i32
	height         i32
	input_id       i32
	input_damage   i32
	furnace_output types.ItemData
}

pub struct CraftingDataPacket {
pub mut:
	entries       []CraftingDataEntry
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
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_varint32(entry.recipe_type)
		match entry.recipe_type {
			0, 5, 6 {
				w.write_varuint32(u32(entry.input.len))
				for item in entry.input {
					item.encode(mut w)
				}
				w.write_varuint32(u32(entry.output.len))
				for item in entry.output {
					item.encode(mut w)
				}
				entry.uuid.encode(mut w)
			}
			1, 7 {
				w.write_varint32(entry.width)
				w.write_varint32(entry.height)
				for item in entry.input {
					item.encode(mut w)
				}
				w.write_varuint32(u32(entry.output.len))
				for item in entry.output {
					item.encode(mut w)
				}
				entry.uuid.encode(mut w)
			}
			2, 3 {
				w.write_varint32(entry.input_id)
				if entry.recipe_type == 3 {
					w.write_varint32(entry.input_damage)
				}
				entry.furnace_output.encode(mut w)
			}
			4 {
				entry.uuid.encode(mut w)
			}
			else {}
		}
	}
	w.bool(p.clean_recipes)
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	recipe_count := int(r.read_varuint32()!)
	p.entries = []CraftingDataEntry{cap: recipe_count}
	for _ in 0 .. recipe_count {
		mut entry := CraftingDataEntry{}
		entry.recipe_type = r.read_varint32()!
		match entry.recipe_type {
			0, 5, 6 {
				ingredient_count := int(r.read_varuint32()!)
				entry.input = []types.ItemData{cap: ingredient_count}
				for _ in 0 .. ingredient_count {
					entry.input << types.ItemData.decode(mut r)!
				}
				result_count := int(r.read_varuint32()!)
				entry.output = []types.ItemData{cap: result_count}
				for _ in 0 .. result_count {
					entry.output << types.ItemData.decode(mut r)!
				}
				entry.uuid = types.Uuid.decode(mut r)!
			}
			1, 7 {
				entry.width = r.read_varint32()!
				entry.height = r.read_varint32()!
				grid := int(entry.width * entry.height)
				entry.input = []types.ItemData{cap: grid}
				for _ in 0 .. grid {
					entry.input << types.ItemData.decode(mut r)!
				}
				result_count := int(r.read_varuint32()!)
				entry.output = []types.ItemData{cap: result_count}
				for _ in 0 .. result_count {
					entry.output << types.ItemData.decode(mut r)!
				}
				entry.uuid = types.Uuid.decode(mut r)!
			}
			2, 3 {
				entry.input_id = r.read_varint32()!
				if entry.recipe_type == 3 {
					entry.input_damage = r.read_varint32()!
				}
				entry.furnace_output = types.ItemData.decode(mut r)!
			}
			4 {
				entry.uuid = types.Uuid.decode(mut r)!
			}
			else {
				return error('Unhandled recipe type ${entry.recipe_type}')
			}
		}
		p.entries << entry
	}
	p.clean_recipes = r.bool()!
}
