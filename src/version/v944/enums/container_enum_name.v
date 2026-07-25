module enums

import serializer

pub enum ContainerEnumName as i8 {
	anvil_input_container                   = 0
	anvil_material_container                = 1
	anvil_result_preview_container          = 2
	smithing_table_input_container          = 3
	smithing_table_material_container       = 4
	smithing_table_result_preview_container = 5
	armor_container                         = 6
	level_entity_container                  = 7
	beacon_payment_container                = 8
	brewing_stand_input_container           = 9
	brewing_stand_result_container          = 10
	brewing_stand_fuel_container            = 11
	combined_hotbar_and_inventory_container = 12
	crafting_input_container                = 13
	crafting_output_preview_container       = 14
	recipe_construction_container           = 15
	recipe_nature_container                 = 16
	recipe_items_container                  = 17
	recipe_search_container                 = 18
	recipe_search_bar_container             = 19
	recipe_equipment_container              = 20
	recipe_book_container                   = 21
	enchanting_input_container              = 22
	enchanting_material_container           = 23
	furnace_fuel_container                  = 24
	furnace_ingredient_container            = 25
	furnace_result_container                = 26
	horse_equip_container                   = 27
	hotbar_container                        = 28
	inventory_container                     = 29
	shulker_box_container                   = 30
	trade_ingredient1_container             = 31
	trade_ingredient2_container             = 32
	trade_result_preview_container          = 33
	offhand_container                       = 34
	compound_creator_input                  = 35
	compound_creator_output_preview         = 36
	element_constructor_output_preview      = 37
	material_reducer_input                  = 38
	material_reducer_output                 = 39
	lab_table_input                         = 40
	loom_input_container                    = 41
	loom_dye_container                      = 42
	loom_material_container                 = 43
	loom_result_preview_container           = 44
	blast_furnace_ingredient_container      = 45
	smoker_ingredient_container             = 46
	trade2_ingredient1_container            = 47
	trade2_ingredient2_container            = 48
	trade2_result_preview_container         = 49
	grindstone_input_container              = 50
	grindstone_additional_container         = 51
	grindstone_result_preview_container     = 52
	stonecutter_input_container             = 53
	stonecutter_result_preview_container    = 54
	cartography_input_container             = 55
	cartography_additional_container        = 56
	cartography_result_preview_container    = 57
	barrel_container                        = 58
	cursor_container                        = 59
	created_output_container                = 60
	smithing_table_template_container       = 61
	crafter_level_entity_container          = 62
	dynamic_container                       = 63
	recipe_food_container                   = 64
	recipe_blocks_container                 = 65
	recipe_furnace_items_container          = 66
}

pub fn (e ContainerEnumName) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ContainerEnumName.decode(mut r serializer.Reader) !ContainerEnumName {
	return unsafe { ContainerEnumName(r.i8()!) }
}
