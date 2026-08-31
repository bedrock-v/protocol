module enums

import protocol.serializer

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
	recipe_book                = 21
	enchanting_input           = 22
	enchanting_material        = 23
	furnace_fuel               = 24
	furnace_ingredient         = 25
	furnace_result             = 26
	horse_equip                = 27
	hotbar                     = 28
	inventory                  = 29
	shulker_box                = 30
	trade_ingredient_1         = 31
	trade_ingredient_2         = 32
	trade_result               = 33
	offhand                    = 34
	compound_creator_input     = 35
	compound_creator_output    = 36
	element_constructor_output = 37
	material_reducer_input     = 38
	material_reducer_output    = 39
	lab_table_input            = 40
	loom_input                 = 41
	loom_dye                   = 42
	loom_material              = 43
	loom_result                = 44
	blast_furnace_ingredient   = 45
	smoker_ingredient          = 46
	trade2_ingredient_1        = 47
	trade2_ingredient_2        = 48
	trade2_result              = 49
	grindstone_input           = 50
	grindstone_additional      = 51
	grindstone_result          = 52
	stonecutter_input          = 53
	stonecutter_result         = 54
	cartography_input          = 55
	cartography_additional     = 56
	cartography_result         = 57
	barrel                     = 58
	cursor                     = 59
	created_output             = 60
	smithing_table_template    = 61
}

pub fn (e ContainerSlotType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn ContainerSlotType.decode(mut r serializer.Reader) !ContainerSlotType {
	return unsafe { ContainerSlotType(r.u8()!) }
}
