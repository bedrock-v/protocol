module enums

pub enum CommandParam as i32 {
	int              = 1
	float            = 3
	value            = 4
	wildcard_int     = 5
	operator         = 6
	compare_operator = 7
	target           = 8
	wildcard_target  = 10
	file_path        = 17
	int_range        = 23
	equipment_slots  = 38
	string           = 39
	block_position   = 47
	position         = 48
	message          = 51
	text             = 53
	json             = 57
	block_states     = 67
	command          = 70
}
