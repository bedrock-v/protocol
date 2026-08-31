module enums

pub enum ItemStackRequestActionType as u32 {
	take                             = 0
	place                            = 1
	swap                             = 2
	drop                             = 3
	destroy                          = 4
	consume                          = 5
	create                           = 6
	place_in_item_container          = 7
	take_from_item_container         = 8
	lab_table_combine                = 9
	beacon_payment                   = 10
	mine_block                       = 11
	craft_recipe                     = 12
	craft_recipe_auto                = 13
	craft_creative                   = 14
	craft_recipe_optional            = 15
	craft_repair_and_disenchant      = 16
	craft_loom                       = 17
	craft_non_implemented_deprecated = 18
	craft_results_deprecated         = 19
}
