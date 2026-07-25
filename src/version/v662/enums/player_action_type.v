module enums

import serializer

pub enum PlayerActionType as i32 {
	start_destroy_block                = 0
	abort_destroy_block                = 1
	stop_destroy_block                 = 2
	get_updated_block                  = 3
	drop_item                          = 4
	start_sleeping                     = 5
	stop_sleeping                      = 6
	respawn                            = 7
	start_jump                         = 8
	start_sprinting                    = 9
	stop_sprinting                     = 10
	start_sneaking                     = 11
	stop_sneaking                      = 12
	creative_destroy_block             = 13
	change_dimension_ack               = 14
	start_gliding                      = 15
	stop_gliding                       = 16
	deny_destroy_block                 = 17
	crack_block                        = 18
	change_skin                        = 19
	deprecated_updated_enchanting_seed = 20
	start_swimming                     = 21
	stop_swimming                      = 22
	start_spin_attack                  = 23
	stop_spin_attack                   = 24
	interact_with_block                = 25
	predict_destroy_block              = 26
	continue_destroy_block             = 27
	start_item_use_on                  = 28
	stop_item_use_on                   = 29
	handled_teleport                   = 30
	missed_swing                       = 31
	start_crawling                     = 32
	stop_crawling                      = 33
	start_flying                       = 34
	stop_flying                        = 35
	client_ack_server_data             = 36
	start_item_use                     = 37
}

pub fn (e PlayerActionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PlayerActionType.decode(mut r serializer.Reader) !PlayerActionType {
	return unsafe { PlayerActionType(r.read_varint32()!) }
}
