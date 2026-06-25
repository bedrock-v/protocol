module enums

pub enum PlayerAction {
	start_break                  = 0
	abort_break                  = 1
	stop_break                   = 2
	get_updated_block            = 3
	drop_item                    = 4
	start_sleeping               = 5
	stop_sleeping                = 6
	respawn                      = 7
	jump                         = 8
	start_sprint                 = 9
	stop_sprint                  = 10
	start_sneak                  = 11
	stop_sneak                   = 12
	creative_player_destroy_block = 13
	dimension_change_ack         = 14
	start_glide                  = 15
	stop_glide                   = 16
	build_denied                 = 17
	crack_break                  = 18
	change_skin                  = 19
	set_enchantment_seed         = 20
	start_swimming               = 21
	stop_swimming                = 22
	start_spin_attack            = 23
	stop_spin_attack             = 24
	interact_block               = 25
	predict_destroy_block        = 26
	continue_destroy_block       = 27
}
