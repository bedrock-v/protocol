module enums

import serializer

pub enum PlayerAuthInputData as i32 {
	ascend                              = 0
	descend                             = 1
	north_jump_deprecated               = 2
	jump_down                           = 3
	sprint_down                         = 4
	change_height                       = 5
	jumping                             = 6
	auto_jumping_in_water               = 7
	sneaking                            = 8
	sneak_down                          = 9
	up                                  = 10
	down                                = 11
	left                                = 12
	right                               = 13
	up_left                             = 14
	up_right                            = 15
	want_up                             = 16
	want_down                           = 17
	want_down_slow                      = 18
	want_up_slow                        = 19
	sprinting                           = 20
	ascend_block                        = 21
	descend_block                       = 22
	sneak_toggle_down                   = 23
	persist_sneak                       = 24
	start_sprinting                     = 25
	stop_sprinting                      = 26
	start_sneaking                      = 27
	stop_sneaking                       = 28
	start_swimming                      = 29
	stop_swimming                       = 30
	start_jumping                       = 31
	start_gliding                       = 32
	stop_gliding                        = 33
	perform_item_interaction            = 34
	perform_block_actions               = 35
	perform_item_stack_request          = 36
	handle_teleport                     = 37
	emoting                             = 38
	missed_swing                        = 39
	start_crawling                      = 40
	stop_crawling                       = 41
	start_flying                        = 42
	stop_flying                         = 43
	client_ack_server_data              = 44
	is_in_client_predicted_vehicle      = 45
	paddling_left                       = 46
	paddling_right                      = 47
	block_breaking_delay_enabled        = 48
	horizontal_collision                = 49
	vertical_collision                  = 50
	down_left                           = 51
	down_right                          = 52
	start_using_item                    = 53
	is_camera_relative_movement_enabled = 54
	is_rot_controlled_by_move_direction = 55
	start_spin_attack                   = 56
	stop_spin_attack                    = 57
	is_hotbar_only_touch                = 58
	jump_released_raw                   = 59
	jump_pressed_raw                    = 60
	jump_current_raw                    = 61
	sneak_released_raw                  = 62
	sneak_pressed_raw                   = 63
	sneak_current_raw                   = 64
	internal_update                     = 65
}

pub fn (e PlayerAuthInputData) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PlayerAuthInputData.decode(mut r serializer.Reader) !PlayerAuthInputData {
	return unsafe { PlayerAuthInputData(r.read_varint32()!) }
}
