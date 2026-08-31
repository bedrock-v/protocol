module enums

pub enum ItemStackRequestActionType as u8 {
	take                             = 0
	place                            = 1
	swap                             = 2
	drop                             = 3
	destroy                          = 4
	consume                          = 5
	create                           = 6
	lab_table_combine                = 7
	beacon_payment                   = 8
	mine_block                       = 9
	craft_recipe                     = 10
	craft_recipe_auto                = 11
	craft_creative                   = 12
	craft_recipe_optional            = 13
	craft_repair_and_disenchant      = 14
	craft_loom                       = 15
	craft_non_implemented_deprecated = 16
	craft_results_deprecated         = 17
}
