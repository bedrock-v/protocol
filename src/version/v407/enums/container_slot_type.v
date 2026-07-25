module enums

import serializer

pub enum ContainerSlotType as u8 {
	anvil_input                = 0
	anvil_material             = 1
	anvil_result               = 2
	smithing_table_input       = 3
	smithing_table_material    = 4
	smithing_table_result      = 5
	armor                      = 6
	level_entity               = 7
	beacon_payment             = 8
	brewing_input              = 9
	brewing_result             = 10
	brewing_fuel               = 11
	hotbar_and_inventory       = 12
	crafting_input             = 13
	crafting_output            = 14
	recipe_construction        = 15
	recipe_nature              = 16
	recipe_items               = 17
	recipe_search              = 18
	recipe_search_bar          = 19
	recipe_equipment           = 20
	enchanting_input           = 21
	enchanting_material        = 22
	furnace_fuel               = 23
	furnace_ingredient         = 24
	furnace_result             = 25
	horse_equip                = 26
	hotbar                     = 27
	inventory                  = 28
	shulker_box                = 29
	trade_ingredient_1         = 30
	trade_ingredient_2         = 31
	trade_result               = 32
	offhand                    = 33
	compound_creator_input     = 34
	compound_creator_output    = 35
	element_constructor_output = 36
	material_reducer_input     = 37
	material_reducer_output    = 38
	lab_table_input            = 39
	loom_input                 = 40
	loom_dye                   = 41
	loom_material              = 42
	loom_result                = 43
	blast_furnace_ingredient   = 44
	smoker_ingredient          = 45
	trade2_ingredient_1        = 46
	trade2_ingredient_2        = 47
	trade2_result              = 48
	grindstone_input           = 49
	grindstone_additional      = 50
	grindstone_result          = 51
	stonecutter_input          = 52
	stonecutter_result         = 53
	cartography_input          = 54
	cartography_additional     = 55
	cartography_result         = 56
	barrel                     = 57
	cursor                     = 58
	created_output             = 59
}

pub fn (e ContainerSlotType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn ContainerSlotType.decode(mut r serializer.Reader) !ContainerSlotType {
	return unsafe { ContainerSlotType(r.u8()!) }
}
