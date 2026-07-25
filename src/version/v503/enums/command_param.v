module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 3
	value           = 4
	wildcard_int    = 5
	operator        = 6
	target          = 7
	wildcard_target = 9
	file_path       = 16
	equipment_slots = 37
	string          = 38
	block_position  = 46
	position        = 47
	message         = 50
	text            = 52
	json            = 56
	block_states    = 66
	command         = 69
}
