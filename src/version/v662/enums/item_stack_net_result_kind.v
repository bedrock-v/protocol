module enums

import protocol.serializer

pub enum ItemStackNetResultKind as i8 {
	success                                                 = 0
	error                                                   = 1
	invalid_request_action_type                             = 2
	action_request_not_allowed                              = 3
	screen_handler_end_request_failed                       = 4
	item_request_action_handler_commit_failed               = 5
	invalid_request_craft_action_type                       = 6
	invalid_craft_request                                   = 7
	invalid_craft_request_screen                            = 8
	invalid_craft_result                                    = 9
	invalid_craft_result_index                              = 10
	invalid_craft_result_item                               = 11
	invalid_item_net_id                                     = 12
	missing_created_output_container                        = 13
	failed_to_set_created_item_output_slot                  = 14
	request_already_in_progress                             = 15
	failed_to_init_sparse_container                         = 16
	result_transfer_failed                                  = 17
	expected_item_slot_not_fully_consumed                   = 18
	expected_anywhere_item_not_fully_consumed               = 19
	item_already_consumed_from_slot                         = 20
	consumed_too_much_from_slot                             = 21
	mismatch_slot_expected_consumed_item                    = 22
	mismatch_slot_expected_consumed_item_net_id_variant     = 23
	failed_to_match_expected_slot_consumed_item             = 24
	failed_to_match_expected_allowed_anywhere_consumed_item = 25
	consumed_item_out_of_allowed_slot_range                 = 26
	consumed_item_not_allowed                               = 27
	player_not_in_creative_mode                             = 28
	invalid_experimental_recipe_request                     = 29
	failed_to_craft_creative                                = 30
	failed_to_get_level_recipe                              = 31
	failed_to_find_recipe_by_net_id                         = 32
	mismatched_crafting_size                                = 33
	missing_input_sparse_container                          = 34
	mismatched_recipe_for_input_grid_items                  = 35
	empty_craft_results                                     = 36
	failed_to_enchant                                       = 37
	missing_input_item                                      = 38
	insufficient_player_level_to_enchant                    = 39
	missing_material_item                                   = 40
	missing_actor                                           = 41
	unknown_primary_effect                                  = 42
	primary_effect_out_of_range                             = 43
	primary_effect_unavailable                              = 44
	secondary_effect_out_of_range                           = 45
	secondary_effect_unavailable                            = 46
	dst_container_equal_to_created_output_container         = 47
	dst_container_and_slot_equal_to_src_container_and_slot  = 48
	failed_to_validate_src_slot                             = 49
	failed_to_validate_dst_slot                             = 50
	invalid_adjusted_amount                                 = 51
	invalid_item_set_type                                   = 52
	invalid_transfer_amount                                 = 53
	cannot_swap_item                                        = 54
	cannot_place_item                                       = 55
	unhandled_item_set_type                                 = 56
	invalid_removed_amount                                  = 57
	invalid_region                                          = 58
	cannot_drop_item                                        = 59
	cannot_destroy_item                                     = 60
	invalid_source_container                                = 61
	item_not_consumed                                       = 62
	invalid_num_crafts                                      = 63
	invalid_craft_result_stack_size                         = 64
	cannot_remove_item                                      = 65
	cannot_consume_item                                     = 66
	screen_stack_error                                      = 67
}

pub fn (e ItemStackNetResultKind) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ItemStackNetResultKind.decode(mut r serializer.Reader) !ItemStackNetResultKind {
	return unsafe { ItemStackNetResultKind(r.i8()!) }
}
